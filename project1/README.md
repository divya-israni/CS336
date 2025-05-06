## Known Issues:
PSQL implicitly casts ‘1’ into int 1 when inserting into a table with an int attribute,
which doesn’t cause that many issues but it’s still a minor bug. When PSQL tries to cast
‘a’ into an int, it will throw an error.

Applications with messed up locations (missing msamd, county, etc.) aren’t in the final
rejoined table because of the way we constructed our location primary key. But this issue
only affects a small portion of the loan applications.

## Resources:
Official PostgreSQL documentation https://www.postgresql.org/docs/17/index.html used for:
 - importing csv into database
 - exporting table to csv
 - explicit type casting to turn preliminary table into typed_preliminary table
 - serial data type
 - numeric data type
 - view to table
 - cascade drop for easier debugging
## Other sources:
 - https://files.consumerfinance.gov/hmda-historic-data-dictionaries/lar_record_codes.pdf
 - inserting values into reference relations
 - https://wiki.postgresql.org/wiki/Is_distinct_from
 - comparing nullable columns

## Interesting questions:
Some interesting questions about mortgages in NJ our database can answer is which counties
have the highest denial rates, how approval rates differ by race, sex, or ethnicity, and the most
common denial reasons. The database can answer a variety of questions relating to mortgages
in NJ dealing with who was approved for them, who was not, and different factors to explain the why.
It can also answer other interesting questions like how many applicants applied with a co-applicant
and whether that helped, the distribution of income over those accepted and those denied, as well
as the distribution of income between different demographics. It can also answer if applicants with
a certain race, sex, or ethnicity are usually granted smaller loan amounts. It can also answer questions
about trends and many more things. 

## Challenges:
 - having to first create preliminary table with all TEXT type then converting to correct types with a separate table
 - when creating tables with foreign keys, the order in which they are created may result in certain tables not being created
 - deciding if we wanted to create all tables without foreign keys first then use ALTER TABLE later to avoid the previous problem, or to just change the order in which we created the tables
 - assigning a location to a property
 - assigning a property to a loan
 - applicant_income_000s apparently can be null
 - due to the large number of attributes, it was easy to lose track of what certain relations looked like and joining tables improperly as a result, which created even more problems
 - halfway though we decided to change application_id to loan_id because they have the same functionality, and it made things a bit confusing
 - when joining everything back together, left joins were needed for nullable columns
    
  ## Time:
  This project took us at most 12 hours cumulatively between all members to complete, but we had our work cut out for us because we had already normalized the data in project 0.
