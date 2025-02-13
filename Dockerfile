# 使用 NVIDIA CUDA 基础镜像
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# 设置工作目录
WORKDIR /workspace

# 避免交互式配置
ENV DEBIAN_FRONTEND=noninteractive

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# 复制 requirements.txt
COPY requirements.txt .

# 安装 Python 依赖
RUN pip3 install --no-cache-dir -r requirements.txt

# 安装 unsloth
RUN pip3 install --no-cache-dir unsloth[cu121]

# 创建 jupyter 配置目录
RUN mkdir -p /root/.jupyter

# 设置 Jupyter 配置
RUN echo "c.NotebookApp.ip = '0.0.0.0'" > /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8888" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.password = ''" >> /root/.jupyter/jupyter_notebook_config.py

# 暴露 Jupyter 端口
EXPOSE 8888

# 启动 Jupyter
CMD ["jupyter", "notebook", "--allow-root"] 