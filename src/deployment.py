import os
from os import walk
import logging
import subprocess

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


def deployment():
    """
        Automate microservice deployments to serverless kubernetes with Fissio.
    """
    folders = _list_folders()
    folders = _validate_folders(folders)
    _deploy_functions(folders)
    _deploy_microservices_to_serverless_kubernetes()


def _list_folders():
    """
        Get all folder names as list. Individual directory should have './' to indicate path.
    """
    directory_list = list()
    for root, dirs, _ in os.walk("../", topdown=False):
        for name in dirs:
            directory_list.append(os.path.join(root, name))
    return directory_list


def _validate_folders(folders):
    """
        Check that all the required directories are in place and can be used in deployment.
    """
    if "./specs" not in folders:
        logger("Error! spec file not found! Deployment cannot be done.")
        raise FileNotFoundError
    else:
        return folders.remove("./specs")


def _deploy_functions(folders):
    """
        Get existing, deployed functions and compare them to new functions.
    """
    existing_functions = _list_files_in_folder("./specs")
    for folder in folders:
        if not _check_if_function_exists_in_specs(folder, existing_functions):
            # If function not in specs create a new function, create specification and deploy function
            _create_function(folder)
            _create_spec_for_function(folder)
            _create_function_endpoint(folder)


def _list_files_in_folder(folder):
    files = []
    for (_, _, filenames) in walk(folder):
        files.extend(filenames)
    return files


def _check_if_function_exists_in_specs(folder_name, specs_folder):
    """
        Every function deployment is in specs folder. Check that all the microservice foldes have corresponding specification deployment file in specs folder.
    """
    function_deployment_file = _get_function_deployment_file_name(folder_name)
    if function_deployment_file in specs_folder:
        return True
    return False


def _create_function(folder_name):
    subprocess.run(
        [f"fission fn create --name {folder_name} --env python --deploy {folder_name}.zip --entrypoint '{folder_name}/{folder_name}.main'"])


def _create_spec_for_function(folder_name):
    """
        Every fission function needs a specification in order to be deployed. Create specification for a function to specs folder.
    """

    subprocess.run(
        [f"fission function create --spec --name {folder_name} --env python --src './{folder_name}' --entrypoint main.handler"])


def _create_function_endpoint(folder_name):
    subprocess.run(
        [f"fission route create - -function {folder_name} - -url / {folder_name}"])


def _get_function_deployment_file_name(folder_name):
    return f"function-{folder_name}.yaml"


def _deploy_microservices_to_serverless_kubernetes():
    """
        Deploy all microservices to kubernetes. Requires that the microservice has deployment files in the specs-folder.
    """
    subprocess.run(["fission spec apply --wait"])


if __name__ == "__main__":
    deployment()
