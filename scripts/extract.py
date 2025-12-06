import zipfile 
import os
import shutil
import pandas as pd

## --- EXTRACTION ---

# 1. Setup directories
os.makedirs("Zip", exist_ok=True)
os.makedirs("Datasets", exist_ok=True)

# 2. Extract the zip file (The input file from Kestra is named 'zipfile')
try:
    with zipfile.ZipFile("zipfile", "r") as z: # *** Corrected zipfile name to "zipfile" ***
        z.extractall("Zip")
except FileNotFoundError:
    print("Warning: zip not found")

# 3. Flatten the files from 'Zip' subdirectories into 'Datasets'
for root, dirs, files in os.walk("Zip"):
    for file in files:
        src_path = os.path.join(root, file)
        dst_path = os.path.join("Datasets", file)

        # Handle duplicate filenames by appending a counter
        if os.path.exists(dst_path):
            base, ext = os.path.splitext(file)
            count = 1
            while os.path.exists(dst_path):
                dst_path = os.path.join("Datasets", f"{base}_{count}{ext}")
                count += 1

        shutil.copy2(src_path, dst_path)

print("Extraction complete. Files copied to Datasets/")

## --- Data Processing ---

# List files in the newly created Datasets folder
files = os.listdir("Datasets")

# Define the list of tables we expect to process
tables = {
    'user_job':[], 'user_data':[], 'staff_data':[], 'order_data':[], 'order_delays':[],
    'product_list':[], 'merchant_data':[], 'campaign_data':[], 'user_credit_card':[],
    'line_item_data_prices':[], 'line_item_data_products':[], 'order_with_merchant_data':[],
    'transactional_campaign_data':[]
}

# Group filenames by their table name prefix
for table in tables:
    while files:
        filename = files.pop()
        for table in tables:
            if filename.startswith(table):
                tables[table] += [filename]

# Function to read a single file into a Pandas DataFrame
def read(file):
    file_path = os.path.join("Datasets", file)
    df = None
    try:
        if file_path.endswith('.csv'):
            df = pd.read_csv(file_path, sep=None, engine='python')
        elif file_path.endswith('.json'):
            df = pd.read_json(file_path)
        elif file_path.endswith('.pickle') or file_path.endswith('.pkl'):
            df = pd.read_pickle(file_path)
        elif file_path.endswith('.xlsx'):
            df = pd.read_excel(file_path)
        elif file_path.endswith('.html'):
            df = pd.read_html(file_path)[0]
        elif file_path.endswith('.parquet'):
            df = pd.read_parquet(file_path)
        else:
            print(f"Skipping unknown file type: {file}")
    except Exception as e:
        print(f"Error reading file {file}: {e}")
        df = None
    return df

# Function to integrate (concatenate) multiple files for the same table and save as CSV
def integrate(table):
    df = read(tables[table][0])
    if len(tables[table]) > 1:
        for i in range(1, len(tables[table])):
            df = pd.concat([df, read(tables[table][i])], ignore_index=True)

    # Specific transformations
    if table == "user_job":
        df = df[['user_id', 'name', 'job_title', 'job_level']]

    elif table == "user_data":
        df = df[['user_id', 'creation_date', 'name', 'street', 'state', 'city', 'country', 'birthdate', 'gender', 'device_address', 'user_type']]

    elif table == "staff_data":
        df = df[['staff_id', 'name', 'job_level', 'street', 'state', 'city', 'country', 'contact_number', 'creation_date']]

    elif table == "order_data":
        df = df[['order_id', 'user_id', 'estimated arrival', 'transaction_date']]

    elif table == "order_delays":
        df = df[['order_id', 'delay in days']]

    elif table == "product_list":
        df = df[['product_id', 'product_name', 'product_type', 'price']]

    elif table == "merchant_data":
        df = df[['merchant_id', 'creation_date', 'name', 'street', 'state', 'city', 'country', 'contact_number']]

    elif table == "campaign_data":
        df = df[['campaign_id', 'campaign_name', 'campaign_description', 'discount']]

    elif table == "user_credit_card":
        df = df[['user_id', 'name', 'credit_card_number', 'issuing_bank']]
        df['credit_card_number'] = df['credit_card_number'].astype(str).apply(lambda x: f'"{x}"')

    elif table == "line_item_data_prices":
        df = df[['Unnamed: 0', 'order_id', 'price', 'quantity']]
        df = df.rename(columns={'Unnamed: 0': 'line_id'})

    elif table == "line_item_data_products":
        df = df[['Unnamed: 0', 'order_id', 'product_name', 'product_id']]
        df = df.rename(columns={'Unnamed: 0': 'line_id'})

    elif table == "order_with_merchant_data":
        df = df[['order_id', 'merchant_id', 'staff_id']]

    elif table == "transactional_campaign_data":
        df = df[['transaction_date', 'campaign_id', 'order_id', 'estimated arrival', 'availed']]

    else:
        print("Invalid table:", table)
        return

    # Save the final integrated DataFrame to a new CSV file. The task's current working directory
    csv_path = os.path.join(os.getcwd(), f"{table}.csv")
    df.to_csv(csv_path, index=False)
    print(f"Successfully created: {table}.csv")

# Run the integration for all defined tables
for table in tables:
    integrate(table)

print("\nAll data integration tasks complete.")
