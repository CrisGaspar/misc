import re

# Convert DB query data to list of dictionaries: one per each row
def convert_db_data(db_data):
    data = []
    for entry in db_data:
        data_dict = {}
        entry.store(data_dict)
        data.append(data_dict)
    return data


name_types = ['Region', 'County', 'District']

# Normalizes region and county names to '<name> Region' or '<name> County'
def normalize_name(name):
    # Remove redundant and trailing whitespace
    cleaned_name = re.sub(' +', ' ', name.strip())

    # Ensure that dashes are flanked by exactly 1 space
    # Disabling since different years might have different spacing in the dash case
    #cleaned_parts = cleaned_name.split('-')
    #cleaned_name = ' - '.join([part.strip() for part in cleaned_parts])

    # Split by whitespace so we can do the name types checks
    name_parts = cleaned_name.split()

    if len(name_parts) == 1:
        # no match for special types
        return cleaned_name

    for name_type in name_types:
        # check if name starts with '<name_type>'
        if name_parts[0].lower() == name_type.lower():
            actual_name_start = 1
            # check if name starts with '<name_type> of'
            if name_parts[1].lower() == 'of'.lower():
                actual_name_start = 2
            # Re-order so <name_type> is at the end
            new_name_parts = name_parts[actual_name_start:]
            new_name_parts.append(name_type)
            return ' '.join(new_name_parts)

    # no match for special types
    return cleaned_name
