# Running

Because AZUSA requires apkg process to be running in order to work, you need to add the required capabilities to the image.

	docker run --rm -it --privileged --cap-add SYS_ADMIN --cap-add MKNOD azusaos/azusa:latest /bin/bash -i
