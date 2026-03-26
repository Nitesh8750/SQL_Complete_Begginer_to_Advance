import os
import pandas as pd

directory = "excel_files/"
output_file = "Dispatch.xlsx"

combined_data = pd.DataFrame()  # Create an empty DataFrame

with pd.ExcelWriter(output_file, engine='xlsxwriter') as writer:
    for file in os.listdir(directory):
        if file.endswith(".xlsx"):
            df = pd.read_excel(os.path.join(directory, file))
            combined_data = pd.concat([combined_data, df], ignore_index=True)  # Append data

    # Rename columns
    combined_data = combined_data.rename(columns={
        'loan_id': 'Loan Id',
        'Tracking Id': 'Tracking Id',
        'Name': 'Customer Name',
        'Address': 'Customer Address',
        'Pincode': 'Customer Pincode',
        'State': 'State',


        # Add more columns as needed
    })

    combined_data.to_excel(writer, sheet_name="Merged_Data", index=False)  # Write to single sheet

print(f"Excel files merged into '{output_file}' (single sheet) with renamed columns.")

