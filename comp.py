import os

def list_v_files_recursively(root_dir):
    with open("comp.txt", "w") as outfile:
        for dirpath, dirnames, filenames in os.walk(root_dir):
            for filename in filenames:
                if filename.endswith(".v") and "_tb.v" not in filename:
                    relative_path = os.path.relpath(os.path.join(dirpath, filename), root_dir)
                    outfile.write(relative_path + "\n")

if __name__ == "__main__":
    current_dir = os.path.dirname(os.path.abspath(__file__))
    list_v_files_recursively(current_dir)
    print("File list saved to comp.txt")