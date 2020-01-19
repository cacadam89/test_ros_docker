FROM ros:melodic-perception
WORKDIR /root

# Change default shell for RUN per https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work/39777387#39777387
SHELL ["/bin/bash", "-c"]

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

# Modify avahi-config (this has to be done)
RUN perl -p -i -e 's|#allow-interfaces=eth0|allow-interfaces=wlp2s0,wlp2s1|g' /etc/avahi/avahi-daemon.conf

# Set Env Variables for NVIDIA (or else rviz wont work) - https://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Install Pip
RUN apt-get update && apt-get install -y \
    python-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Scipy Requirements
RUN apt-get update && apt-get install -y \
    build-essential \
    libc-dev \
    && rm -rf /var/lib/apt/lists/* && \
    pip install -U pip

# Install Scipy
RUN pip install scipy

# ---------------------------- DEBUG -start ------------------------------ #
# Install: ping, locate, nano, x11-apps (xclock)
RUN apt-get update && apt-get install -y \
        iputils-ping \
        mlocate \
        nano \
        x11-apps \
    && rm -rf /var/lib/apt/lists/*
# ---------------------------- DEBUG - end ------------------------------ #

# ---------------------------- Reset argument ------------------------------ #
ARG rebuild=0
# -------------------------------------------------------------------------- #

# Add aliases to bashrc in docker containers
RUN echo 'alias test_go="roslaunch wf_comparison demo_with_rviz.launch bag_filename:=/bags/cartographer_paper_deutsches_museum.bag"' >> ~/.bashrc

# # Re-pull & Build if ARG rebuild changed
RUN source /ros_entrypoint.sh && \
    cd test_ros_ws/src/test_ros_docker && \
    git pull && \
    cd ~/test_ros_ws && \
    catkin_make

# Set GIT config based on local env vars
ARG GIT_NAME=
ARG GIT_EMAIL=
RUN git config --global user.email "$GIT_EMAIL" && \
    git config --global user.name "$GIT_NAME"

# Append source line to bashrc
RUN echo "source /test_ros_entrypoint.sh" >> ~/.bashrc
COPY ./test_ros_entrypoint.sh /

ENTRYPOINT ["/test_ros_entrypoint.sh"]
CMD ["bash"]
