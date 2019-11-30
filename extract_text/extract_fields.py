import re

#criminal complaint
def find_docket_number(document):
    docket = re.search("[0-9]{4}[A-Z]{2}[0-9]{5}", document)
    if(docket != None):
        return docket.group()
    return "Docket number not found"

def find_full_name(document):
    name = re.search("[A-Z][a-z]*\s[A-Z]\s[A-Z][a-z]*", document)
    if(name != None):
        return name.group()
    return "Name not found"

def find_dates(document):
    dates = re.findall("[0-9]{2}/[0-9]{2}/[0-9]{4}", document)
    if(dates != None):
        return dates
    return "No dates found"

#application for criminal complaint
def find_name_ACC(document):
    name = re.search("[a-z]*\s[A-Z][a-z]*[,]\s[A-Z][a-z]*", document)
    return name