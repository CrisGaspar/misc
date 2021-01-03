import re

# Convert DB query data to list of dictionaries: one per each row
def convert_db_data(db_data):
    data = []
    for entry in db_data:
        data_dict = {}
        entry.store(data_dict)
        data.append(data_dict)
    return data


name_types = ['Region', 'County']

# Normalizes region and county names to '<name> Region' or '<name> County'
def normalize_name(name):
    # Remove redundant and trailing whitespace
    cleaned_name = re.sub(' +', ' ', name.strip())
    name_parts = cleaned_name.split()

    if len(name_parts) == 1:
        # no match for special types
        return name

    for name_type in name_types:
        # check if name starts with 'Region' or 'County'
        if name_parts[0].lower() == name_type.lower():
            actual_name_start = 1
            # check if name starts with 'Region of' or 'County of'
            if name_parts[1].lower() == 'of'.lower():
                actual_name_start = 2
            # Re-order so Region or County is at the end
            new_name_parts = name_parts[actual_name_start:]
            new_name_parts.append(name_type)
            return ' '.join(new_name_parts)

    # no match for special types
    return name
