FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

WORKDIR /

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_PREFER_BINARY=1 \
    PYTHONUNBUFFERED=1 \
    CUDA_HOME=/usr/local/cuda \
    PATH=/usr/local/cuda/bin:/opt/venv/bin:$PATH \
    ENVIRONMENT=PRODUCTION \
    COMFYUI_ROOT=/comfyui

# Build arguments for git commit hashes - these will invalidate cache when changed
ARG COMFYUI_COMMIT_HASH
ARG INSPIRE_PACK_COMMIT_HASH

# Install Python, system dependencies, build tools, and CUDA
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    git \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip \
    libgl1 \
    libglib2.0-0 \
    wget \
    build-essential \
    gcc \
    g++ \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment for Python and install requirements
RUN python3.10 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip

# # Install PyTorch with explicit compatible versions
# # Using the most recent stable versions that work well together
# RUN /opt/venv/bin/pip install --no-cache-dir \
#     torch==2.4.1+cu124 \
#     torchvision==0.19.1+cu124 \
#     torchaudio==2.4.1+cu124 \
#     --index-url https://download.pytorch.org/whl/cu124

# Clone ComfyUI and install its dependencies
RUN echo "Building ComfyUI at commit: ${COMFYUI_COMMIT_HASH}" && \
    git clone https://github.com/comfyanonymous/ComfyUI.git ${COMFYUI_ROOT} && \
    cd ${COMFYUI_ROOT} && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Clone ComfyUI custom nodes
RUN echo "Building Inspire Pack at commit: ${INSPIRE_PACK_COMMIT_HASH}" && \
    git clone https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git ${COMFYUI_ROOT}/custom_nodes/ComfyUI-Inspire-Pack && \
    cd ${COMFYUI_ROOT}/custom_nodes/ComfyUI-Inspire-Pack && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

WORKDIR /

# Copy the Python dependencies (requirements.txt) and install
COPY requirements.txt /requirements.txt
RUN /opt/venv/bin/pip install --no-cache-dir -r /requirements.txt

# Copy application code
RUN mkdir -p /app
COPY src/ /app/
RUN chmod +x /app/main.sh

# Set the final command
CMD ["/app/main.sh"]
