library(dplyr)


#### Read all data from Assets folder
data_path <- file.path("Assets/finance", list.files("Assets/finance", pattern = "*ScheduleH.csv"))
dominion_path <- file.path("Assets/finance", list.files("Assets/finance", pattern = "*ScheduleA.csv"))
map_path <- file.path("Assets/finance", list.files("Assets/finance", pattern = "*Report.csv"))
candidates_path <- file.path("Assets/election", list.files("Assets/election", pattern = "*CandidateCampaignCommittee.csv"))

data_files <- lapply(data_path, read.csv)
dominion_files <- lapply(dominion_path, read.csv)
map_files <- lapply(map_path, read.csv)
 candidates_files <- lapply(candidates_path, read.csv)
#translate lapply to for loop
# candidates_files <- list()
# for (i in 1:length(candidates_path)) {
#     print(candidates_path[[i]])
#     candidates_files[[i]] <- read.csv(candidates_path[[i]])
# }


finance_data <- do.call(rbind, data_files)
dominion <- do.call(rbind, dominion_files)
finance_map <- do.call(rbind, map_files)
candidates <- do.call(rbind, candidates_files)
candidates <- subset(candidates, grepl("2023 November", candidates$ElectionName))


house <- subset(candidates, grepl("Delegate", candidates$OfficeSoughtName))






### Union on ReportUID
mapped_data <- left_join(finance_data, finance_map, by = join_by(ReportUID == ReportUID))
mapped_dom <- left_join(dominion, finance_map, by = join_by(ReportUID == ReportUID))

#### Only use candidates whose cycle ends this year
mapped_data <- subset(mapped_data, mapped_data$ElectionCycleEndDate == "2023-12-31 00:00:00")

mapped_dom <- subset(mapped_dom, mapped_dom$CommitteeType == "Candidate Campaign Committee")
mapped_dom <- subset(mapped_dom, mapped_dom$IsIndividual == "False")
mapped_dom <- subset(mapped_dom, grepl("Dominion|DE", mapped_dom$LastOrCompanyName))
mapped_dom$District <- as.numeric(gsub("\\D+", "", mapped_dom$District))

hod_dom <- subset(mapped_dom, grepl("Delegate", mapped_dom$OfficeSought))


# Join house and hod_dom on committeCode if the office sought is House of Delegats
hod_dom <- left_join(house, hod_dom, by = join_by(CommitteeCode == CommitteeCode))

View(mapped_dom)

# join house and finance map on committee code

house <- left_join(house, mapped_data, by = join_by(CommitteeCode == CommitteeCode))
house <- house[order(rev(house$SubmittedDate)), ] 
house <- house[!duplicated(house$CommitteeCode), ]
#### Making dataframes for each type of district, but only using HoD right now.
# sd <- subset(mapped_data, mapped_data$OfficeSought == "Member Senate of Virginia")
# sd$District <- as.numeric(gsub("\\D", "", sd$District))

house$District <- as.numeric(gsub("\\D", "", house$DistrictName))

#### None this year
# cd <- subset(mapped_data, mapped_data$OfficeSought == "Member Senate of Virginia")
# cd$District <- as.numeric(gsub("\\D", "", hod$District))

# View(sd)

#### Commented out so you can run and view the table without overwriting any files
write.csv(house, "Assets/finance/2022_House_Finances.csv")
write.csv(hod_dom, "Assets/finance/2022_House_Dom.csv")
