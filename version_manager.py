#!/bin/python
"""
This script manage versions of CI/CD pipeline
"""

VERSION_FILE = "/root/atom-monitoring/build_versions.txt"
PACKER_FILE = "/root/atom-monitoring/packer/packer.json"
TERRAFORM_FILE = "/root/atom-monitoring/terraform/static-web.tf"
TERRAFORM_VAR_FILE = "/root/atom-monitoring/terraform/terraform.tfvars"


def file_operations(file_name, find_value, replace_line_with):
    """
    This function take exactly 3 arguments to open file find a str value & relace line
    """
    with open(file_name) as file_in:
        data = file_in.readlines()

    for line_data in data:
        if find_value in line_data:
            data[data.index(line_data)] = replace_line_with

    with open(file_name, "w") as file_out:
        file_out.writelines(data)
    return None

try:
    with open(VERSION_FILE) as v_file:
        PREVIOUS_BUILD = v_file.readlines()[-1].strip()

    OLD_BUILD_NAME = PREVIOUS_BUILD.split("-")
    NEW_VERSION = "v" + str(int(OLD_BUILD_NAME[-1].strip("v").strip('"')) + 1)
    OLD_BUILD_NAME[-1] = NEW_VERSION + '"'
    LATEST_BUILD = "-".join(OLD_BUILD_NAME)

    with open(VERSION_FILE, "a") as v_file:
        v_file.write(LATEST_BUILD + "\n")

    file_operations(PACKER_FILE, "Name", '        "Name": ' + LATEST_BUILD + "\n")
except IOError:
    with open(PACKER_FILE) as p_file:
        P_FILE = p_file.readlines()
        for line in P_FILE:
            if "Name" in line:
                LATEST_BUILD = line.split(":")[1].strip()
    with open(VERSION_FILE, "w") as v_file:
        v_file.write(LATEST_BUILD + "\n")


file_operations(TERRAFORM_FILE, "values", \
    "    values = [" + LATEST_BUILD + "]\n")
file_operations(TERRAFORM_FILE, "name        =", \
    "  name        = " + LATEST_BUILD + "\n")
file_operations(TERRAFORM_VAR_FILE, "tag", \
    "tag = " + LATEST_BUILD + "\n")

