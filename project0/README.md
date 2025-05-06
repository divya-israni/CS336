# Issues?
No.

## Resources
https://www.bytebase.com/blog/postgres-timeout/ -- Setting statement timeout in postgres to allow full database to be loaded
https://neon.tech/postgresql/postgresql-tutorial/import-csv-file-into-posgresql-table -- How to upload a CSV to a postgres table
https://www.geeksforgeeks.org/postgresql-serial/ -- Understanding SERIAL datatype in Postgres

# Insights + Rules

Based off the attributes, we could gather the following insights about mortgage loans in NJ in 2017:
1. Loan approval and denial rate differences between different demographics (ethnicity, race, sex).
2. Which lenders/agencies are most likely to give out loans to what demographics and/or regions.
3. Correlation between applicant income and loan type and amount. i.e. What types of loans are wealthier people getting and what types of loans are poorer people getting?
4. Which regions receive more mortgage loans, and the approval/denial rates in those regions.

The rules we used to construct the entities were the following:
1. Minimize empty, superfluous columns (e.g., race2, race3) and instead create a join table to model the many to many relationship, ensuring we only store the data that we need without a ton of null values.
2. Prevent repetitive/duplicated data by creating "enum" entities which act as simple key-value pairs that store an id and a description/name of that id.
    1. These types of columns were very common in the original denormalized data (denial type, loan purpose, loan type, msamd type, etc.). By creating these enums as tables, we can define the known keys and values in one place and can reference them without duplicating that data for each loan. All we'd need to do is join on the id of that enum.


# Problems/Challenges We Faced
1. Without domain knowledge, constructing some of the entities were a bit challenging.
2. Some group members did not have access to the table, even after creating it under the shared group database. We had to manually grant all privileges to those user ids.
3. We could not add an empty ID column to represent the primary key in our table as it will contain NULL values. Instead, we changed it to be a serial type to hold an auto-incrementing id.
    1. `sequence_number` was empty in our dataset which meant we needed to create a new id column for a loan.
4. There are a lot of columns that are missing most if not all of their values.
5. For respondent information, we did not know if an `edit_status` was for a specific loan or a specific agency. We assumed it was for a specific loan, which meant each respondent is for a specific loan and each respondent can be 1 of a set of agencies.

We took about 3-4 hours in total to complete the project.

