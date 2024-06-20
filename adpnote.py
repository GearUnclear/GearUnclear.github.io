import os
import re
import sys
import pandas as pd
from collections import defaultdict
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QLineEdit, QLabel,
    QPushButton, QTextEdit, QCompleter, QMessageBox
)
from PyQt5.QtGui import (
    QStandardItemModel, QStandardItem, QDesktopServices, QMovie
)
from PyQt5.QtCore import (
    Qt, QUrl, QEvent, QObject, QTimer, QThread, pyqtSignal
)
import requests

class DownloadThread(QThread):
    download_finished = pyqtSignal(str)

    def __init__(self, url, destination):
        super().__init__()
        self.url = url
        self.destination = destination

    def run(self):
        response = requests.get(self.url, stream=True)
        if response.status_code == 200:
            with open(self.destination, 'wb') as f:
                for chunk in response.iter_content(1024):
                    f.write(chunk)
            self.download_finished.emit(self.destination)
        else:
            self.download_finished.emit(None)

class FocusEventFilter(QObject):
    def __init__(self, callback):
        super().__init__()
        self.callback = callback

    def eventFilter(self, obj, event):
        if event.type() == QEvent.FocusIn:
            self.callback()
        return False

class MainWindow(QMainWindow):
    def launch_adp_link(self):
        QDesktopServices.openUrl(QUrl("https://workforcenow.adp.com/theme/index.html#/Myself/MyselfTabTimecardsAttendanceSchCategoryTLMWebMyTimecard"))

    def __init__(self):
        super().__init__()
        self.setWindowTitle("Data Entry Application")
        self.setGeometry(100, 100, 320, 300)  # Adjusted for potentially more space

        # Load CSV data
        try:
            self.load_csv_data()
        except FileNotFoundError:
            self.create_blank_csv()
            QMessageBox.information(self, "Info", "No matching files found. A new CSV file has been created. Please click the 'Update' button to download the required data.")
        except pd.errors.EmptyDataError:
            QMessageBox.warning(self, "Warning", "The CSV file is empty. Creating an empty DataFrame.")
            self.data = pd.DataFrame(columns=["First", "Last", "Assigned Programs", "MoveInDate", "Exit Date"])
        except Exception as e:
            QMessageBox.critical(self, "Error", f"An error occurred: {str(e)}. Creating an empty DataFrame.")
            self.data = pd.DataFrame(columns=["First", "Last", "Assigned Programs", "MoveInDate", "Exit Date"])

        # Extract first and last names for autocomplete
        self.first_names = self.data['First'].unique()
        self.last_names = self.data['Last'].unique()

        # Main layout and central widget setup
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.main_layout = QVBoxLayout(self.central_widget)

        # Row management buttons
        self.manage_buttons_layout = QHBoxLayout()
        self.add_row_button = QPushButton("Add Row")
        self.remove_row_button = QPushButton("Remove Row")
        self.manage_buttons_layout.addWidget(self.add_row_button)
        self.manage_buttons_layout.addWidget(self.remove_row_button)
        self.main_layout.addLayout(self.manage_buttons_layout)

        # Data entry area
        self.rows_area = QVBoxLayout()
        self.main_layout.addLayout(self.rows_area)

        # Submission and output
        self.submit_button = QPushButton("Submit")
        self.main_layout.addWidget(self.submit_button)

        # Text output area
        self.text_box = QTextEdit()
        self.text_box.setReadOnly(True)
        self.main_layout.addWidget(self.text_box)

        self.copy_button = QPushButton("Copy to Clipboard")
        self.main_layout.addWidget(self.copy_button)

        # New button to launch ADP link
        self.launch_adp_button = QPushButton("Open ADP Timecard (Click Again After Login)")
        self.launch_adp_button.clicked.connect(self.launch_adp_link)
        self.main_layout.addWidget(self.launch_adp_button)

        # New maroon update button
        self.update_button = QPushButton("Update")
        self.update_button.setStyleSheet("background-color: maroon; color: white;")
        self.update_button.clicked.connect(self.show_gif)
        self.main_layout.addWidget(self.update_button)

        # Connect signals
        self.add_row_button.clicked.connect(self.add_row)
        self.remove_row_button.clicked.connect(self.remove_row)
        self.submit_button.clicked.connect(self.format_and_display_data)
        self.copy_button.clicked.connect(self.copy_text)

        # Initial row
        self.add_row()

        # Apply styles
        self.apply_dark_mode()

        # Start the GIF download
        self.download_gif()

    def load_csv_data(self):
        home_directory = os.path.expanduser("~")
        downloads_directory = os.path.join(home_directory, "Downloads")
        pattern = r"FSC_ Client Info - New Section(?: \((\d+)\))?.csv"

        max_num = -1
        selected_file = None

        for filename in os.listdir(downloads_directory):
            match = re.search(pattern, filename)
            if match:
                num = int(match.group(1)) if match.group(1) else 0
                if num > max_num:
                    max_num = num
                    selected_file = filename

        if selected_file:
            latest_csv_path = os.path.join(downloads_directory, selected_file)
            print(f"Loading file: {latest_csv_path}")
            self.data = pd.read_csv(latest_csv_path)

            # Remove rows with no MoveInDate and rows with Exit Date
            self.data.dropna(subset=["MoveInDate"], inplace=True)
            self.data = self.data[self.data["Exit Date"].isna()]
        else:
            raise FileNotFoundError("No matching files found.")

    def create_blank_csv(self):
        home_directory = os.path.expanduser("~")
        downloads_directory = os.path.join(home_directory, "Downloads")
        latest_csv_path = os.path.join(downloads_directory, "FSC_ Client Info - New Section.csv")
        self.data = pd.DataFrame(columns=["First", "Last", "Assigned Programs", "MoveInDate", "Exit Date"])
        self.data.to_csv(latest_csv_path, index=False)

    def add_row(self):
        row_layout = QHBoxLayout()
        first_name_label = QLabel("First:")
        first_name_entry = QLineEdit()
        last_name_label = QLabel("Last:")
        last_name_entry = QLineEdit()
        hours_label = QLabel("Hours:")
        hours_entry = QLineEdit()

        # Create completers
        first_name_completer = QCompleter(self.first_names)
        first_name_completer.setCaseSensitivity(Qt.CaseInsensitive)
        first_name_entry.setCompleter(first_name_completer)

        # Set last name completer without setting model yet
        last_name_completer = CustomCompleter()
        last_name_completer.setCaseSensitivity(Qt.CaseInsensitive)
        last_name_entry.setCompleter(last_name_completer)

        # Connect signal for dynamic update of last names based on first name input
        first_name_entry.textChanged.connect(lambda: self.preload_last_names(first_name_entry.text(), last_name_completer))

        # Focus event filter for last name field
        last_name_focus_filter = FocusEventFilter(lambda: self.update_last_names(first_name_entry.text(), last_name_completer))
        last_name_entry.installEventFilter(last_name_focus_filter)

        row_layout.addWidget(first_name_label)
        row_layout.addWidget(first_name_entry)
        row_layout.addWidget(last_name_label)
        row_layout.addWidget(last_name_entry)
        row_layout.addWidget(hours_label)
        row_layout.addWidget(hours_entry)

        self.rows_area.addLayout(row_layout)

    def preload_last_names(self, first_name, completer):
        """
        Preload the possible last names based on the entered first name but
        do not display them until the last name field is focused.
        """
        filtered_data = self.data[self.data['First'].str.lower() == first_name.lower()]
        last_names = filtered_data['Last'].unique()

        # Update completer model
        model = QStandardItemModel()
        for name in last_names:
            model.appendRow(QStandardItem(name))
        completer.setModel(model)

    def update_last_names(self, first_name, completer):
        """
        Update last names to be shown in the completer for the last name field.
        """
        filtered_data = self.data[self.data['First'].str.lower() == first_name.lower()]
        last_names = filtered_data['Last'].unique()

        # Update completer model
        model = QStandardItemModel()
        for name in last_names:
            model.appendRow(QStandardItem(name))
        completer.setModel(model)

        # Ensure completer popup shows all options
        completer.complete()

    def remove_row(self):
        # This method will remove the last row added to the rows_area
        if self.rows_area.count() > 1:  # Ensure there's more than one row to remove
            to_remove = self.rows_area.takeAt(self.rows_area.count() - 1)
            if to_remove:
                # Remove each widget from the layout and delete it
                while to_remove.count():
                    item = to_remove.takeAt(0)
                    widget = item.widget()
                    if widget is not None:
                        widget.deleteLater()
                # Delete the layout itself
                to_remove.deleteLater()

    def format_and_display_data(self):
        # Using a dictionary to aggregate data
        aggregated_data = defaultdict(float)  # Use float for more flexible hour handling

        for i in range(self.rows_area.count()):
            row_layout = self.rows_area.itemAt(i).layout()
            first = row_layout.itemAt(1).widget().text().strip()
            last = row_layout.itemAt(3).widget().text().strip()
            hours_text = row_layout.itemAt(5).widget().text().strip()

            # Skip row if first name, last name, and hours are empty
            if not first and not last and not hours_text:
                continue  # Skip the rest of the loop and move to the next iteration

            hours = float(hours_text) if hours_text else 0  # Convert to float, default to 0 if empty

            # Check if the row corresponds to existing data in the dataset
            row_data = self.data[(self.data['First'].str.lower() == first.lower()) & (self.data['Last'].str.lower() == last.lower())]
            if not row_data.empty:
                assigned_programs = row_data['Assigned Programs'].values[0]
                key = (assigned_programs,)
                # Summing hours for each unique key
                aggregated_data[key] += hours

        formatted_text = ""
        for (assigned_programs,), total_hours in aggregated_data.items():
            # Format total hours to always show at most two decimal places
            formatted_text += f"{get_program_name(assigned_programs)}, Family Support Coach Services, {remove_program_name(assigned_programs)}, {total_hours:.2f} hours\n"

        self.text_box.setText(formatted_text)

    def copy_text(self):
        clipboard = QApplication.clipboard()
        clipboard.setText(self.text_box.toPlainText())

    def apply_dark_mode(self):
        self.setStyleSheet("""
        QWidget { background-color: #333; color: #DDD; }
        QLineEdit, QTextEdit, QPushButton { background-color: #555; color: #DDD; }
        """)

    def download_gif(self):
        gif_url = "https://housinghopedata.site/downloadcsv.gif"
        self.gif_path = os.path.join(os.path.expanduser("~"), "downloaded_gif.gif")

        self.download_thread = DownloadThread(gif_url, self.gif_path)
        self.download_thread.download_finished.connect(self.on_gif_download_finished)
        self.download_thread.start()

    def on_gif_download_finished(self, gif_path):
        if gif_path:
            print("GIF downloaded and ready.")
        else:
            QMessageBox.critical(self, "Error", "Failed to download the GIF.")

    def show_gif(self):
        if os.path.exists(self.gif_path):
            # Create a new window for the GIF
            self.gif_window = QWidget()
            self.gif_window.setWindowFlags(Qt.FramelessWindowHint)
            self.gif_window.setGeometry(0, 0, QApplication.desktop().width(), QApplication.desktop().height())
            
            layout = QVBoxLayout()
            label = QLabel(self.gif_window)
            movie = QMovie(self.gif_path)
            label.setMovie(movie)
            layout.addWidget(label)
            self.gif_window.setLayout(layout)
            self.gif_window.showFullScreen()
            movie.start()

            # Close the window after 10 seconds
            QTimer.singleShot(12000, self.gif_window.close)
            QTimer.singleShot(12000, lambda: QDesktopServices.openUrl(QUrl("https://apricot.socialsolutions.com/report/run/report_id/138")))
        else:
            QMessageBox.critical(self, "Error", "GIF not available. Please try again later.")

def get_program_name(program_input):
    program_names = [
        "Aspenwood", "Avondale", "Beachwood", "Commerce", "Crossroads",
        "Fairview", "Hope Village", "Hope Village Expansion",
        "Lincoln Hill Village", "Maple Leaf Meadows", "Monroe Family Village",
        "New Century Village", "New Century House", "Station Place", "Twin Lakes Landing",
        "Twin Lakes Landing II", "Winters Creek North", "Winters Creek South",
        "Woods Creek Village"
    ]
    program_input = program_input.lower()  # Convert input to lowercase to ensure case-insensitive matching
    # Sort program names by length in descending order
    sorted_program_names = sorted(program_names, key=len, reverse=True)
    for name in sorted_program_names:
        if name.lower() in program_input:
            return name
    return "Unknown Program"  # Return an informative default if no match is found

def remove_program_name(program_input):
    original_input = program_input  # Store the original input

    if "Crossroads" in program_input or "Stanwood House" in program_input:
        return "Shelter"

    # Remove "Housing -" prefix
    program_input = program_input.replace("Housing -", "").strip()
    p_i=program_input
    # Extract the actual program name after the location name
    program_names = [
        "Aspenwood", "Avondale", "Beachwood", "Commerce Bldg", "Crossroads",
        "Fairview", "Hope Village", "Hope Village Expansion",
        "Lincoln Hill Village", "Maple Leaf Meadows", "Monroe Family Village",
        "New Century Village", "New Century House", "Station Place", "Twin Lakes Landing",
        "Twin Lakes Landing II", "Winters Creek North", "Winters Creek South",
        "Woods Creek Village"
    ]
    for name in program_names:
        program_input = program_input.replace(name, '').strip()

    # Remove "II" from the program input
    program_input = program_input.replace("II", "").strip()

    # Check if the resulting string is effectively empty
    if program_input == "" or program_input.isspace():
        return p_i

    return program_input.strip()

class CustomCompleter(QCompleter):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setCompletionMode(QCompleter.UnfilteredPopupCompletion)
        self.setCaseSensitivity(Qt.CaseInsensitive)

    def eventFilter(self, obj, event):
        if event.type() == QEvent.FocusIn:
            self.complete()
        return super().eventFilter(obj, event)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = MainWindow()
    main_window.show()
    sys.exit(app.exec_())
