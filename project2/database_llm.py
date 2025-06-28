from llama_cpp import Llama
import re
import getpass
import subprocess

# Load minimized schema (must be < 4096 tokens with prompt)
with open("llm_input_schema.sql", "r") as f:
    schema = f.read()

# Initialize LLM with GPU offloading (can't figure out how to run on GPU...)
llm = Llama(
    model_path="mistral-7b-instruct-v0.1.Q4_K_M.gguf",
    n_ctx=4096,
    n_gpu_layers=0,
    n_threads=6,
    verbose=True
)

examples = """\
QUESTION: How many mortgages have a loan value greater than the applicant income?
ANSWER:
SELECT COUNT(*)
FROM loan
JOIN applicant ON loan.loan_id = applicant.loan_id
WHERE loan.loan_amount_000s > applicant.applicant_income_000s;

QUESTION: What is the average income of owner occupied applications?
ANSWER:
SELECT AVG(applicant.applicant_income_000s) AS avg_income
FROM loan
JOIN applicant ON loan.loan_id = applicant.loan_id
JOIN property ON loan.property_id = property.property_id
WHERE property.owner_occupancy = 1;
"""

# Prompt user for ILab credentials
ssh_user = input("Enter your ILab NetID: ")

# Main interaction loop
while True:
    user_question = input("\nAsk your database question (or type 'exit' to quit): ")
    if user_question.strip().lower() == "exit":
        break

    # Construct LLM prompt
    prompt = f"""You are an expert SQL assistant that generates valid, efficient, and JOIN-aware PostgreSQL SELECT queries from natural language questions.

    Your task:
    1. Read the database schema and examples below.
    2. Convert the user question into a **single, fully correct SQL SELECT query**.
    3. Return ONLY the SQL query, ending with a semicolon. DO NOT include any explanations or extra text.

    DATABASE SCHEMA:
    {schema}

    EXAMPLES:
    {examples}

    STRICT RULES:
    - Output only a syntactically correct SQL SELECT query.
    - DO NOT use tables or columns that are not defined in the schema.
    - JOIN tables explicitly when the question involves fields from more than one table.
    - Prefer JOINs over correlated subqueries — avoid subqueries in WHERE or SELECT clauses.
    - Always qualify ambiguous column names with their table name (e.g., applicant.applicant_income_000s).
    - Use INNER JOIN unless the question implies otherwise.
    - Do not guess values (e.g., "approved" = 1) unless clearly stated or shown in schema.
    - End the query with a semicolon.
    - Do not return any text other than the SQL query itself.
    - To join Loan and Applicant tables, use the loan_id column.
    - To join Loan and Property tables, use the property_id column.

    USER QUESTION:
    {user_question}

    SQL QUERY:
    """

    max_retries = 3
    attempt = 0
    while attempt < max_retries:
        # Query the LLM
        response = llm(prompt=prompt, max_tokens=200)
        full_text = response['choices'][0]['text']

        # Extract SQL query
        match = re.search(r"SELECT .*?;", full_text, re.IGNORECASE | re.DOTALL)
        if not match:
            attempt += 1
            print(f"(Attempt {attempt}) Could not extract SQL query. LLM returned:\n", full_text)
            continue

        query = match.group(0).strip()
        print(f"\nExtracted SQL Query:\n{query}")

        # Send query to ILab via SSH
        try:
            ssh_command = [
                "ssh",
                f"{ssh_user}@ilab.cs.rutgers.edu",
                f'python3 /common/home/ycw7/Documents/cs336/ilab_script.py "{query}"'
            ]
            result = subprocess.run(ssh_command, text=True, capture_output=True)
            
            # Check for 'error' in stdout or stderr
            if "error" not in result.stdout.lower() and "error" not in result.stderr.lower():
                # Print output
                print("\nQuery Result:\n", result.stdout)
                break
            else:
                attempt += 1
                print(f"Retrying ... (attempt {attempt})")

            if result.stderr:
                print("Errors:", result.stderr)
        except Exception as e:
            print("Error during SSH call:", e)
    else:
        print("Max retries reached. Exiting.")

# How many mortgages have a loan value greater than the applicant income?
# What is the average income of owner occupied applications?
# What is the most common loan denial reason?
# How many loans were for owner-occupied properties?
# How many loans were approved?
# How many loans were denied?
