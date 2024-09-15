# Factors predicting college application numbers in New York State
**This is a project I did for my R course during my master's program, where I noticed a decline in college applications in the United States.
  So I decided to find out the reasons that attract students' applications, specifically from college characteristics. The full code, dataset and paper are available.**
- **Data Source**: Custom dataset selection tools from [Integrated Postsecondary Education Data System (IPEDS) project](https://nces.ed.gov/ipeds!)
) on the National Center for Education Statistics website 

- **Variables description**
  #### Table 1: Numeric Variable Descriptions

| Variable            | Description                                      |
|---------------------|--------------------------------------------------|
| `unitid`            | University ID                                    |
| `year`              | The year in which the data was collected (2022) |
| `sf_ratio`          | Student to faculty ratio                        |
| `salary`            | Average faculty salary                          |
| `fees`              | Total cost of tuition and other school fees     |
| `finanAid_percent`  | Percent of students receiving financial aid     |
| `applicants`        | The number of total applicants in 2022          |

  #### Table 2: Categorical Variable Descriptions

| Variable | Description                                   | Levels              | Description                                          |
|----------|-----------------------------------------------|----------------------|------------------------------------------------------|
| `category` | Category of schools classified by the level of offerings | `baccalaureate`      | Degree-granting, primarily baccalaureate or above   |
|          |                                               | `non-baccalaureate`  | Degree-granting, not primarily baccalaureate or above |
|          |                                               | `asso&certificate`   | Degree-granting, Associate's and certificates         |

- **Results**
  <br> **-Main findings**
  <br> Average faculty salary, annual tuition and fees, the number of students receiving financial aid, and school category were significant predictors of the number of college applications.
  <br> 
  <br> log(applicants)=β0+ β1salary+β2fees+β3finanai_percent+ β4category +ϵ.
  <br>
  <br> *Model results*
  <br> <img width="649" alt="Screenshot 2024-09-14 at 21 08 11" src="https://github.com/user-attachments/assets/b56bb87d-3c5d-4fb9-aba8-3c6030f22abd">
  <br> 
<br> **-Degree categorical differences**
  <br> On average, schools that primarily offer baccalaureate or higher degrees receive the most applications, followed by schools that primarily offer nonbaccalaureate and associate's degrees and certificates.

  <img width="416" alt="Screenshot 2024-09-14 at 21 21 44" src="https://github.com/user-attachments/assets/9958e369-6a7b-4310-8172-a56baa2d81de">

<img width="520" alt="Screenshot 2024-09-14 at 21 22 56" src="https://github.com/user-attachments/assets/d1417032-ad33-42b2-b9fd-1113d49bf75b">


  
