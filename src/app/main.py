from Flask import request


def main():
    req_body = request.body
    query_string_parameters = req_body["queryStringParameters"]
