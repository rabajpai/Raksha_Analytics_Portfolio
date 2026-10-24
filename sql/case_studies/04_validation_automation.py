# ============================================================
# -- DATA VALIDATION AUTOMATION SCRIPT
# -- File: 04_validation_automation.py
#
# PURPOSE:
# This Python script automates the reconciliation of data between a
# source file (CSV) and a target database table. It simulates a common
# task in data remediation and migration projects, generating a
# summary report and a detailed file of discrepancies.
#
# PREREQUISITES:
# 1.  Install required libraries: pip install pandas sqlalchemy sqlite3
# 2.  The script is designed to run with a local SQLite database for
#     demonstration. It can easily be adapted to connect to BigQuery,
#     SQL Server, or Oracle by changing the SQLAlchemy connection string.
#
# HOW TO RUN:
# 1.  Ensure this script is in the same directory as 'source_data.csv'.
# 2.  Run from your terminal: python 04_validation_automation.py
#
# ============================================================

import pandas as pd
from sqlalchemy import create_engine
import sqlite3
import os

# --- Configuration ---
SOURCE_CSV_FILE = 'source_data.csv'
DB_FILE = 'target_database.db'
TARGET_TABLE_NAME = 'transactions'

# 1. SET UP THE SIMULATED ENVIRONMENT
# ====================================
# Create dummy data for the demonstration to be self-contained.
def setup_dummy_environment():
    """Creates sample source and target data for the simulation."""
    print("--- Setting up simulated environment ---")

    # Create a DataFrame representing the 'source' data
    source_data = pd.DataFrame({
        'CustomerID': [1, 1, 2, 2, 3, 4, 5],
        'TransactionDate': pd.to_datetime(['2023-10-01', '2023-10-01', '2023-10-01', '2023-10-02', '2023-10-02', '2023-10-03', '2023-10-03']),
        'Amount': [100.50, 50.25, 200.00, 75.00, 120.00, 300.00, 500.00]
    })

    # Introduce errors to simulate a faulty migration
    target_data = pd.DataFrame({
        'CustomerID': [1, 1, 2, 2, 3, 6, 7],
        'TransactionDate': pd.to_datetime(['2023-10-01', '2023-10-01', '2023-10-01', '2023-10-02', '2023-10-02', '2023-10-04', '2023-10-04']),
        'Amount': [100.50, 50.25, 200.00, 75.00, 120.00, 50.00, 75.00] # Customer 3 amount is wrong
    })

    # Write source data to CSV
    source_data.to_csv(SOURCE_CSV_FILE, index=False)
    print(f"Created simulated source file: {SOURCE_CSV_FILE}")

    # Write target data to a SQLite database
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)
    engine = create_engine(f'sqlite:///{DB_FILE}')
    target_data.to_sql(TARGET_TABLE_NAME, engine, index=False, if_exists='replace')
    print(f"Created simulated target database: {DB_FILE}")
    print("--- Environment setup complete ---\n")
    return source_data, target_data

# 2. THE VALIDATION LOGIC
# =========================
def run_validation(source_df, target_df):
    """Performs the validation and prints a report."""
    print("--- Running Data Validation ---")

    # Aggregate the data to the level we want to compare
    source_agg = source_df.groupby(['CustomerID', 'TransactionDate']).agg(
        Source_Count=('Amount', 'count'),
        Source_Sum=('Amount', 'sum')
    )
    target_agg = target_df.groupby(['CustomerID', 'TransactionDate']).agg(
        Target_Count=('Amount', 'count'),
        Target_Sum=('Amount', 'sum')
    )

    # Perform a FULL OUTER JOIN using Pandas merge
    recon_df = pd.merge(
        source_agg,
        target_agg,
        left_index=True,
        right_index=True,
        how='outer'
    )

    # Identify the discrepancies
    recon_df['Status'] = 'MATCH'
    recon_df.loc[recon_df['Source_Count'].isnull(), 'Status'] = 'MISSING_IN_TARGET'
    recon_df.loc[recon_df['Target_Count'].isnull(), 'Status'] = 'EXTRA_IN_TARGET'
    
    # This is the mismatch condition
    mismatch_mask = (recon_df['Source_Count'] != recon_df['Target_Count']) | (recon_df['Source_Sum'] != recon_df['Target_Sum'])
    recon_df.loc[mismatch_mask & (recon_df['Status'] == 'MATCH'), 'Status'] = 'MISMATCH_SUM'

    # 3. GENERATE THE REPORT
    # ========================
    print("\n--- Validation Report Summary ---")
    
    mismatch_report = recon_df[recon_df['Status'] != 'MATCH']
    
    total_records = len(recon_df)
    total_mismatches = len(mismatch_report)
    
    print(f"Total groups checked: {total_records}")
    print(f"Total mismatches found: {total_mismatches}")
    
    if total_mismatches > 0:
        print("\n--- Discrepancies Found ---")
        print(mismatch_report)
        
        # Save the report to a CSV file
        report_filename = 'validation_discrepancies.csv'
        mismatch_report.to_csv(report_filename)
        print(f"\nDetailed report saved to: {report_filename}")
    else:
        print("\nAll records match perfectly. No discrepancies found.")
        
    print("--- Validation Complete ---")


# --- MAIN EXECUTION ---
if __name__ == "__main__":
    # Setup and get the data
    source_df, _ = setup_dummy_environment()
    
    # Load the data as the script would in a real scenario
    loaded_source_df = pd.read_csv(SOURCE_CSV_FILE, parse_dates=['TransactionDate'])
    engine = create_engine(f'sqlite:///{DB_FILE}')
    loaded_target_df = pd.read_sql_table(TARGET_TABLE_NAME, engine, parse_dates={'TransactionDate': '%Y-%m-%d'})

    # Run the validation
    run_validation(loaded_source_df, loaded_target_df)
