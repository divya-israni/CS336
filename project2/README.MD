## What we found challenging:
    - Setting up the LLM
    - Prompting the LLM
    - LLM kept joining loan and applicant tables on applicant_id when it should've used loan_id
    - Understanding SSH tunnels

## What we found interesting:
    - One fix in the prompt seemed to solve a lot of problems (telling it explicitly which columns to use to join tables)
    - How hard LLM prompting is
    - If you accidentally don't input anything the LLM will give you questions to ask


## Dependencies:
    - pandas
    - psycopg2
    - llama_cpp_python

## LLM Model: mistral-7b-instruct-v0.1.Q4_K_M.gguf

## Main chat transcript:
    https://chatgpt.com/share/68183621-fdac-8013-ab7d-792cdb2b70e9
    (other chat transcripts are included as images)
