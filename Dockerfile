# 使用 Python 3.9 作为基础镜像
FROM python:3.9-slim

# 如果需要 GPU 支持，可以修改基础镜像为
#FROM nvidia/cuda:11.0-cudnn8-runtime-ubuntu20.04

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 包
RUN pip install --no-cache-dir \
    numpy>=1.19.0 \
    pandas>=1.2.0 \
    scipy>=1.6.0 \
    scikit-learn>=0.24.0 \
    lightgbm>=3.2.0 \
    torch>=1.7.0 \
    torchkeras>=2.1.0 \
    deepctr>=0.8.2 \
    matplotlib>=3.3.0 \
    jupyter>=1.0.0 \
    notebook>=6.0.0 \
    tqdm>=4.50.0 \
    pickle-mixin>=1.0.2 \
    pyfm>=0.2.0 \
    deepmatch>=0.3.0 \
    tensorflow==2.3.0

# 安装额外的依赖（根据项目需要添加）
RUN pip install --no-cache-dir \
    seaborn \
    plotly \
    ipywidgets \
    jupyterlab

# 或者从 requirements.txt 安装
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 创建非 root 用户
RUN useradd -m -s /bin/bash jupyter

# 设置工作目录权限
RUN chown -R jupyter:jupyter /app

# 切换到非 root 用户
USER jupyter

# 暴露 Jupyter 端口
EXPOSE 8888

# 启动 Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]