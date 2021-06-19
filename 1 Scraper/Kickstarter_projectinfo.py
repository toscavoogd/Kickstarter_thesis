from datetime import datetime
import json
import time

from io import BytesIO
import requests
try:
    from urllib.request import urlopen
except ImportError:
    from urllib import urlopen
import xlsxwriter

from urllib.request import urlopen
from bs4 import BeautifulSoup
import pandas as pd
import sys
import re


def addEntry(worksheet, row, details):
    """
        Add a new entry to the excel sheet.
        :params obj worksheet: XLSX Worksheet object.
        :params int row: Row to write to.
        :params list details: Information to be written.
        :params obj image_data: Image to the written.
    """
    print ("Adding",details[1],"to row",row)
    col=0
    for item in details:
        worksheet.write(row, col, item)
        col+=1

def generate_URL():
    base_url = "https://www.kickstarter.com/discover/advanced.json?&page="

    return base_url


def init_header_row(workbook, worksheet):
    """
        Adds the header rows to the excel sheet
        :params obj workbook: XLSX workbook object.
        :params obj worksheet: XLSX worksheet object.
    """
    print("Initializing Worksheet")
    bold = workbook.add_format({'bold': True})
    worksheet.write(0, 0, "Rank", bold)
    worksheet.write(0, 1, "Project_ID", bold)
    worksheet.write(0, 2, "Name", bold)
    worksheet.write(0, 3, "Creator's Name", bold)
    worksheet.write(0, 4, "Goal", bold)
    worksheet.write(0, 5, "Pledged Amount", bold)
    worksheet.write(0, 6, "Percentage Fulfilled", bold)
    worksheet.write(0, 7, "Status", bold)
    worksheet.write(0, 8, "Backers", bold)
    worksheet.write(0, 9, "Launch Date", bold)
    worksheet.write(0, 10, "Deadline", bold)
    worksheet.write(0, 11, "URL", bold)
    worksheet.write(0, 12, "Duration(days)", bold)

if __name__ == "__main__":
    """Main Function"""

    url = generate_URL()
    
    try:
        print("Creating Excel File")
        filename = 'kickstarter_data.xlsx'
        workbook = xlsxwriter.Workbook(filename)
        print("Adding New Sheet")
        worksheet = workbook.add_worksheet()
        init_header_row(workbook, worksheet)
    except Exception as e:
        print("ERROR: "), e.message
    else:
        page = 1
        total = 0
        ctr = 1
        
        try:
            pages = int(input("Enter Number of pages to scrape (1 page = 12 entries): "))
        except:
            print("Please enter Valid Numeric value")
        else:
            if pages<=0:
                print("Enter Valid number of pages")
            else:
                while page<=pages:
                    print("Collecting Data for page"),page
                    r = requests.get(url + str(page))
                    if r.status_code!=200:
                        print("Connection Error! Status:"),r.status_code
                        break
                    data = r.json()

                    total += len(data["projects"])
                    for index in range(len(data["projects"])):
                        details = []

                        details.append(ctr)
                        details.append(data["projects"][index]["id"])
                        details.append(data["projects"][index]["name"])
                        details.append(data["projects"][index]["creator"]["name"])
                        
                        goal = int(data["projects"][index]["goal"])
                        pledged = int(data["projects"][index]["pledged"])

                        details.append(goal)
                        details.append(pledged)
                        details.append(float(data["projects"][index]["pledged"]/data["projects"][index]["goal"])*100)
                            
                        launch_date = time.strftime('%c', time.localtime(data["projects"][index]["launched_at"]))
                        deadline = time.strftime('%c', time.localtime(data["projects"][index]["deadline"]))

                        details.append(data["projects"][index]["state"])
                        details.append(data["projects"][index]["backers_count"])
                        details.append(launch_date)
                        details.append(deadline)

                        #category = int(data["projects"][index]["category"]["parent_id"])
                        #details.append(category)
                        #details.append(data["projects"][index]["category"]["parent_name"])

                        project_url = (data["projects"][index]["urls"]["web"]["project"])
                        details.append(project_url)

                        l_date = datetime.strptime(launch_date,'%c')
                        d_date = datetime.strptime(deadline,'%c')
                        details.append(abs((l_date-d_date).days))

                        #projecturl = (data["projects"][index]["urls"]["web"]["project"])
                        #rd = requests.get(url + str(page))

                        addEntry(worksheet, ctr, details)
                        ctr += 1

                    print("\n")
                    page += 1

        try:
            print("Closing Workbook")
            workbook.close()
            print("Closed Workbook")
        except:
            print("Unable to close Excel File. Please close the file if open.")
            print("Entries not written to file")
        else:
            print("Added", total, "entries")