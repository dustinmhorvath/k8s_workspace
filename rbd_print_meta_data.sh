rbd ls kubernetes | grep csi | xargs -I {} sh -c 'echo "\n{}"; rbd image-meta list kubernetes/{}'
