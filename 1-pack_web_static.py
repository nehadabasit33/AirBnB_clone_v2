#!/usr/bin/python3
"""
Fabric script that generates a .tgz archive from the contents of the
web_static folder of the AirBnB Clone repo
"""
import datetime
import os
import tarfile


def do_pack():
    """Generates a .tgz archive"""
    try:
        # Get the current working directory (where the script is located)
        current_directory = os.getcwd()

        # Define the name of the archive
        timestamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        archive_name = 'web_static_{}.tgz'.format(timestamp)

        # Define the path to the version folder
        versions_folder = os.path.join(current_directory, 'versions')

        # Create the versions folder if it doesn't exist
        if not os.path.exists(versions_folder):
            os.makedirs(versions_folder)

        # Function to filter out hidden directories and files
        def is_hidden(path):
            return os.path.basename(path).startswith('.')

        # Create the full path to the archive
        archive_path = os.path.join(versions_folder, archive_name)

        # Create a .tgz archive, excluding hidden directories/files
        with tarfile.open(archive_path, 'w:gz') as tar:
            for root, dirs, files in os.walk(current_directory):
                # Exclude hidden directories
                dirs[:] = [
                    d for d in dirs if not is_hidden(os.path.join(root, d))
                ]
                for file in files:
                    # Exclude hidden files
                    if not is_hidden(file):
                        file_path = os.path.join(root, file)
                        tar.add(
                            file_path, arcname=os.path.relpath(
                                file_path, current_directory)
                        )

        return archive_path

    except Exception:
        return None
