import os
import argparse
import sys

def scan(file, folder):
    root = os.path.dirname(file)
    root = os.path.relpath(folder, start=root)

    resources = {}

    for path, dirs, files in os.walk(folder):
        prefix = path.lstrip(folder) or '/'
        prefix = prefix.replace('\\', '/')
        path = os.path.relpath(path, folder)
        if path == '.':
            path = ''
        resources[prefix] = [{ 'name': f, 'path': os.path.join(root, path, f).replace('\\', '/')} for f in files]

    write_to_qrc(file, resources)
        
def write_to_qrc(file, resources):
    with open(file, 'w') as f:
        f.write('<RCC>\n')
        for prefix in resources:
            f.write('    <qresource prefix="%s">\n' % prefix)
            for r in resources[prefix]:
                f.write('        <file alias="%s">%s</file>\n' % (r['name'], r['path']))
            f.write('    </qresource>\n')
        f.write('</RCC>\n')
           
if __name__=="__main__":
    parser = argparse.ArgumentParser(description='Generates a qrc (Qt resource file) from all files on a directory tree.')
    
    parser.add_argument('qrcfile',
        metavar = 'qrcfile',
        type = str,
        help = 'Path to qrc file.')
    
    parser.add_argument('directory',
        metavar = 'directory', 
        type = str,
        help = 'A valid path, full or local.')

    args = parser.parse_args()
    file = args.qrcfile
    directory = args.directory

    scan(file, directory)