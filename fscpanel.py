import pandas as pd
import tkinter as tk
from tkinter import messagebox
from PIL import Image, ImageTk
import os
import re
from datetime import datetime
from fuzzywuzzy import fuzz
import requests

def load_csv_data(filepath):
    df = pd.read_csv(filepath)
    id_columns = ['Record ID', 'Assessment Record ID', 'Unit Record ID', 'Family Record ID']
    for column in id_columns:
        df[column] = df[column].fillna(-1).astype(int).astype(str).replace('-1', '')
    return df

def save_notes(note_type, record_id):
    base_url = "https://apricot.socialsolutions.com/document/edit/form_id/"
    if note_type == "Contact Documentation":
        form_id = "103"
    elif note_type == "Meeting Narrative":
        form_id = "105"
    else:
        print(f"Unknown note type: {note_type}")
        return
    
    url = f"{base_url}{form_id}/parent_id/{record_id}/id/new"
    open_in_chrome(url)

def open_in_chrome(url):
    command = f'start chrome --new-tab {url}'
    os.system(command)

def format_unit_numbers(filepath):
    df = pd.read_csv(filepath)
    df = df[df['HMIS client number'].astype(str).map(len) <= 6]
    df['Site'] = df['Site'].astype(str)
    df['Line2'] = df['Line2'].astype(str)
    df['Building Number'] = df['Building Number'].fillna('0').astype(str)
    df['Unit Number'] = df['Unit Number'].fillna('').astype(str)

    def modify_line2(row):
        site = row['Site']
        line2 = row['Line2']
        building_number = row['Building Number']
        unit_number = row['Unit Number']
        if site == 'Crossroads':
            return f"XR{line2}".replace(' ', '')
        elif site == 'Stanwood House':
            return f"SH{line2}".replace(' ', '')
        elif site in ['Beachwood', 'Fairview', 'Fairview PSH', 'Hope Village II', 'Hope Village II PSH',
                      'Maple Leaf Meadows PSH', 'Maple Leaf Meadows', 'Winters Creek South',
                      'Winters Creek South PSH'] or 'New Century Village' in site:
            if (site == 'Maple Leaf Meadows PSH' and building_number == '3010') or \
               (site.startswith('New Century Village') and building_number == '1'):
                return line2.replace(' ', '')
            return f"{building_number}{unit_number}".replace(' ', '')
        return line2.replace(' ', '')

    df['xvxunit'] = df.apply(modify_line2, axis=1)

    downloads_folder = os.path.join(os.path.expanduser("~"), "Downloads")
    output_file_name = "processed_quicklink_data.csv"
    output_path = os.path.join(downloads_folder, output_file_name)
    
    df.to_csv(output_path, index=False)
    return output_path

def create_main_window(dataframe):
    window = tk.Tk()
    window.title("Client Search and Open Record")
    window.attributes('-topmost', True)
    window.configure(background='#f0f0f0')
    
    logo_path = "H:\\Marketing\\HH HW Logos\\Housing Hope Logo\\PNG -Transparent background only\\HH_Logo.Small.Transparent.png"
    try:
        img = Image.open(logo_path)
        img = img.resize((173, 84), Image.Resampling.LANCZOS)
        logo = ImageTk.PhotoImage(img)
    except FileNotFoundError:
        print(f"Logo file not found: {logo_path}")
        logo = None
    
    if logo:
        logo_label = tk.Label(window, image=logo, background='#f0f0f0')
        logo_label.image = logo  # Keep a reference to prevent garbage collection
        logo_label.pack(pady=(10, 0))
    
    frame = tk.Frame(window, bg='#f0f0f0')
    frame.pack(pady=10)
    
    search_label = tk.Label(frame, text="Enter HMIS Client Number, First Last Name, or Unit:", bg='#f0f0f0', font=('Arial', 10))
    search_label.grid(row=0, column=0, sticky='w', pady=2)
    
    search_entry = tk.Entry(frame, width=50)
    search_entry.grid(row=1, column=0, pady=2)
    search_entry.bind('<KeyRelease>', lambda event: update_fuzzy_match_info(search_entry.get(), dataframe, results_frame))
    
    result_label = tk.Label(window, text="", bg='#f0f0f0', font=('Arial', 10))
    result_label.pack()
    
    results_frame = tk.Frame(window, bg='#f0f0f0')
    results_frame.pack(fill='both', expand=True, padx=10, pady=10)
    
    search_button = tk.Button(frame, text="Search", command=lambda: on_button_click('search', dataframe, search_entry, None, result_label, results_frame))
    search_button.grid(row=1, column=1, padx=10, pady=2)
    
    url_frame = tk.Frame(frame, bg='#f0f0f0')
    url_label_part1 = tk.Label(url_frame, text="https://apricot.socialsolutions.com/document/edit/id/", bg='#f0f0f0', font=('Arial', 10))
    url_label_part1.pack(side=tk.LEFT)
    
    record_id_entry = tk.Entry(url_frame, width=10)
    record_id_entry.pack(side=tk.LEFT)
    
    url_frame.grid(row=2, column=0, pady=2)
    
    open_button = tk.Button(frame, text="Open Record", command=lambda: on_button_click('open', dataframe, search_entry, record_id_entry, result_label, results_frame))
    open_button.grid(row=2, column=1, padx=10, pady=2)
    
    update_button = tk.Button(window, text="UPDATE", fg='white', bg='blue', font=('Arial', 12, 'bold'), command=lambda: open_in_chrome("https://apricot.socialsolutions.com/report/run/report_id/166"))
    update_button.pack(pady=10)
    
    return window, search_entry, record_id_entry, result_label, results_frame

search_delay_handle = None

def update_fuzzy_match_info(search_query, dataframe, results_frame):
    global search_delay_handle
    if search_delay_handle is not None:
        results_frame.after_cancel(search_delay_handle)
    search_delay_handle = results_frame.after(600, lambda: fuzzy_search_execute(search_query, dataframe, results_frame))

def fuzzy_search_execute(search_query, dataframe, results_frame):
    search_query = search_query.strip().lower()
    matches = []

    for index, row in dataframe.iterrows():
        hmis_score = fuzz.partial_ratio(search_query, str(row['HMIS client number']).lower())
        first_name_score = fuzz.partial_ratio(search_query, str(row['First']).lower())
        last_name_score = fuzz.partial_ratio(search_query, str(row['Last']).lower())
        full_name_score = fuzz.token_sort_ratio(search_query, f"{row['First'].lower()} {row['Last'].lower()}")
        unit_score = fuzz.ratio(search_query, str(row['xvxunit']).lower())
        max_score = max(hmis_score, first_name_score, last_name_score, full_name_score, unit_score)
        
        if (search_query in str(row['HMIS client number']).lower() or
            search_query == str(row['First']).lower() or
            search_query == str(row['Last']).lower() or
            search_query == f"{row['First'].lower()} {row['Last'].lower()}" or
            search_query == str(row['xvxunit']).lower()):
            max_score = 100
        
        if max_score >= 40:
            matches.append((max_score, row['HMIS client number'], row['Record ID'], row['First'], row['Last'], row['Date of Assessment'], row['Assessment Record ID'], row['Family Record ID'], row['Unit Record ID'], row['xvxunit'], row['Site']))

    grouped_matches = {}
    for match in matches:
        key = (match[1], match[2], match[3], match[4], match[8], match[7], match[9], match[10])
        if key not in grouped_matches:
            grouped_matches[key] = {
                'HMIS client number': match[1],
                'Record ID': match[2],
                'First': match[3],
                'Last': match[4],
                'Unit Record ID': match[8],
                'Family Record ID': match[7],
                'xvxunit': match[9],
                'Site': match[10],
                'Assessments': []
            }
        grouped_matches[key]['Assessments'].append({'assessment_id': match[6], 'date': match[5]})

    sorted_matches = sorted(grouped_matches.values(), key=lambda x: max(fuzz.partial_ratio(search_query, str(x['HMIS client number']).lower()),
                                                                         fuzz.partial_ratio(search_query, str(x['First']).lower()),
                                                                         fuzz.partial_ratio(search_query, str(x['Last']).lower()),
                                                                         fuzz.token_sort_ratio(search_query, f"{x['First'].lower()} {x['Last'].lower()}"),
                                                                         fuzz.ratio(search_query, str(x['xvxunit']).lower())), reverse=True)

    display_search_results(sorted_matches[:10], results_frame)

def display_search_results(results, parent_frame):
    for widget in parent_frame.winfo_children():
        widget.destroy()

    def get_selected_assessment(assessments, selected_date):
        for assessment in assessments:
            if assessment['date'] == selected_date.split(": ")[1]:
                return assessment['assessment_id']
        return None

    def update_assessment_link(selected_date, assessments, button):
        selected_assessment_id = get_selected_assessment(assessments, selected_date)
        if selected_assessment_id:
            button.config(command=lambda: open_in_chrome(f"https://apricot.socialsolutions.com/document/edit/id/{selected_assessment_id}"))

    for i, client in enumerate(results):
        result_frame = tk.Frame(parent_frame, borderwidth=1, relief="solid")
        result_frame.pack(padx=10, pady=5, fill='x')
        
        result_frame.grid_columnconfigure(0, weight=1)
        
        client_info = tk.Label(
            result_frame, 
            text=f"{client['First']} {client['Last']} ({client['HMIS client number']}) - {client['Site']}: {client['xvxunit']}",
            font=('Arial', 12, 'bold'),
            fg='#0066cc'
        )
        client_info.grid(row=0, column=0, columnspan=8, sticky="w", padx=10, pady=5)
        
        buttons = [
            ("Profile", lambda r=client['Record ID']: open_in_chrome(f"https://apricot.socialsolutions.com/document/edit/id/{r}")),
            ("Family", lambda f=client['Family Record ID']: open_in_chrome(f"https://apricot.socialsolutions.com/document/edit/id/{f}")),
            ("Folder", lambda r=client['Record ID']: open_in_chrome(f"https://apricot.socialsolutions.com/profile/index/id/{r}")),
            ("Unit", lambda u=client['Unit Record ID']: open_in_chrome(f"https://apricot.socialsolutions.com/document/edit/id/{u}")),
            ("Contact Documentation", lambda r=client['Record ID']: save_notes("Contact Documentation", r)),
            ("Meeting Narrative", lambda r=client['Record ID']: save_notes("Meeting Narrative", r))
        ]
        
        for col, (text, command) in enumerate(buttons):
            tk.Button(result_frame, text=text, command=command).grid(row=1, column=col, padx=2, pady=2, sticky="ew")
        
        assessment_var = tk.StringVar(result_frame)
        assessment_button = tk.Button(result_frame, text="Assessment")
        assessment_button.grid(row=1, column=6, padx=2, pady=2, sticky="ew")

        if client['Assessments']:
            assessment_var.set(f"Assessment Date: {client['Assessments'][0]['date']}")
            assessment_dropdown = tk.OptionMenu(
                result_frame,
                assessment_var,
                *[f"Assessment Date: {a['date']}" for a in client['Assessments']],
                command=lambda selected_date, a=client['Assessments'], b=assessment_button: update_assessment_link(selected_date, a, b)
            )
            assessment_dropdown.grid(row=1, column=7, padx=2, pady=2, sticky="ew")
            update_assessment_link(assessment_var.get(), client['Assessments'], assessment_button)

        for col in range(8):
            result_frame.grid_columnconfigure(col, weight=1)

def on_button_click(action_type, dataframe, search_entry, record_id_entry, result_label, results_frame):
    if action_type in ['search', 'profile', 'folder']:
        search_query = search_entry.get()
        if not search_query:
            result_label.config(text="Please enter a search term.")
            return
        results = search_client(search_query, dataframe)
        if results:
            display_search_results(results, results_frame)
            result_label.config(text=f"{len(results)} results found.")
        else:
            result_label.config(text="No results found.")
    elif action_type == 'open':
        record_id = record_id_entry.get().strip()
        if record_id:
            url = f"https://apricot.socialsolutions.com/document/edit/id/{record_id}"
            result_label.config(text=f"Opening record ID: {record_id}")
            open_in_chrome(url)
        else:
            result_label.config(text="Please enter a Record ID.")

def search_client(search_query, df):
    search_query = search_query.strip().lower()
    filtered_df = df[df['HMIS client number'].astype(str).str.lower() == search_query]
    if filtered_df.empty and " " in search_query:
        first_name, last_name = search_query.split(" ", 1)
        filtered_df = df[(df['First'].str.lower() == first_name) & (df['Last'].str.lower() == last_name)]
    if filtered_df.empty:
        filtered_df = df[df['xvxunit'].astype(str).str.lower() == search_query]
    aggregated_data = filtered_df.groupby(['HMIS client number', 'First', 'Last', 'xvxunit', 'Record ID', 'Family Record ID', 'Unit Record ID', 'Site']).agg({
        'Date of Assessment': lambda x: [datetime.strptime(str(date), '%m/%d/%Y') if pd.notnull(date) else pd.NaT for date in x],
        'Assessment Record ID': lambda x: list(x)
    }).reset_index()
    results = [
        {
            'HMIS client number': row['HMIS client number'],
            'First': row['First'],
            'Last': row['Last'],
            'xvxunit': row['xvxunit'],
            'Record ID': row['Record ID'],
            'Family Record ID': row['Family Record ID'],
            'Unit Record ID': row['Unit Record ID'],
            'Site': row['Site'],
            'Assessments': [{'date': date.strftime('%m/%d/%Y') if pd.notnull(date) else '', 'assessment_id': assessment_id}
                            for date, assessment_id in zip(row['Date of Assessment'], row['Assessment Record ID'])]
        }
        for index, row in aggregated_data.iterrows()
    ]
    return results

def main():
    home_directory = os.path.expanduser("~")
    directory = os.path.join(home_directory, "Downloads")
    pattern = r"tryingtoquicklinkagain - New Section \((\d+)\).csv"
    max_num = -1
    selected_file = None

    for filename in os.listdir(directory):
        match = re.search(pattern, filename)
        if match:
            num = int(match.group(1))
            if num > max_num:
                max_num = num
                selected_file = filename
    if selected_file:
        original_csv_path = os.path.join(directory, selected_file)
    else:
        print("No matching files found.")
        return
    processed_csv_path = format_unit_numbers(original_csv_path)
    dataframe = load_csv_data(processed_csv_path)
    window, search_entry, record_id_entry, result_label, fuzzy_match_info = create_main_window(dataframe)
    window.mainloop()

if __name__ == "__main__":
    main()
