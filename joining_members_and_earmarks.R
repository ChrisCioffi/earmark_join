library(tidyverse)
library(fuzzyjoin)
#I made this more difficult for no reason, but the left join function is v. useful.
#Data was accessed from here https://www.congress.gov/help/field-values/member-bioguide-ids for member_id and here: https://democrats-appropriations.house.gov/sites/democrats.appropriations.house.gov/files/Community%20Project%20Funding%20Request%20Table%20Member%20Requests%20FY23.xlsx for the complete earmark requests.  

#I split them in Google sheets using text-to-columns, because I didn't feel like writing it out in R. Here's the doc: https://docs.google.com/spreadsheets/d/e/2PACX-1vQ9zNkYGGkxM1Zn0BG-cB0TYKIzgfRN50cDBsOyABt-VveQiOwjI98anInrf-6p4LC5w9X2yN_BXzfA/pubhtml
#In earmarks I went through in excel and got rid of characters like à and è becasue it was only a couple of instances of them

earmarks <- read_csv("earmarks.csv")
member_id <- read_csv("split_member_id.csv")
all_members <- read_csv("house_members.csv")

#in the interest of time, I clipped both name columns to be 10 characters long. Enough to be distinct, but not long enough to get mixed up with Jr and Sr and all that other stuff


earmarks_trimmed <- earmarks %>%
                      mutate( new_id = str_sub(Member, end = 10))
member_id_trimmed <- member_id %>%
                      mutate( new_id = str_sub(Member, end = 10))
cq_id_trimmed <- all_members %>%
                      mutate( new_id = str_sub(Member, end = 10))

#a list of all members who requested earmarks. 
joined_list <- left_join(earmarks_trimmed, member_id_trimmed, by = "new_id")



#write_csv(joined_list, "joinedlist.csv")

#the two I had to fix manually after joining was Jennifer Gonzales Colon and Cathy McMorris Rogers

#now that it's fixed I'm going to read it back in and join it with the members who did not request earmarks.
fixed_joined_list <- read_csv("joinedlist.csv")

#joining the list of all members of the House with the members requesting earmarks.
comprehensive_list <- left_join(cq_id_trimmed, joined_list, by = "new_id")

#write that file out

write_csv(comprehensive_list, "membersandearmarks.csv")

#this was a fun attempt, but it was a little off, and I just didn't have time to tinker.
temp <- cosponsors %>%
  stringdist_inner_join(member_id, by = c("split_name"= "Member"))
