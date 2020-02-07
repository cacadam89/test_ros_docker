FROM ros:melodic-perception

# Create and Initialize Catkin Workspace
RUN source /ros_entrypoint.sh && \
    mkdir -p test_ros_ws/src && \
    cd ~/test_ros_ws && \
    catkin_make

# Get Source
RUN source /ros_entrypoint.sh && \
    cd test_ros_ws/src && \
    git clone https://github.com/cacadam89/test_ros_docker.git test_ros_docker && \
    cd .. && \
    catkin_make


# Install Pip & Scipy Requirements
RUN apt-get update && \
    apt-get install -y build-essential  libc-dev  python-pip && \
    pip install -U pip

# Install Python Dependencies (Scipy, Matplotlib)
RUN pip install \
    scipy \
    matplotlib

# Add aliases to bashrc in docker containers
RUN echo 'alias my_alias_go="this alias will be available in my docker container!"' >> ~/.bashrc

# Copy and execute entrypoint
COPY ./test_ros_entrypoint.sh /
ENTRYPOINT ["/test_ros_entrypoint.sh"]
CMD ["bash"]
