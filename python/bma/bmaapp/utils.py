# Convert DB query data to list of dictionaries: one per each row
def convert_db_data(db_data):
    data = []
    for entry in db_data:
        data_dict = {}
        entry.store(data_dict)
        data.append(data_dict)
    return data
