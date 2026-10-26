# Use official lightweight Python 3.11 Debian Bookworm image
FROM python:3.11-slim-bookworm

# Prevent Python from writing .pyc files and buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=7860

WORKDIR /app

# Install system dependencies required by WeasyPrint and Persian/Arabic font rendering
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libharfbuzz-subset0 \
    libjpeg62-turbo \
    libopenjp2-7 \
    libffi8 \
    shared-mime-info \
    fonts-noto-core \
    fonts-dejavu-core \
    fontconfig \
    && fc-cache -fv \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files (including Excel catalog and bot script)
COPY . .

# Expose port for Render / Koyeb health checks
EXPOSE 7860

# Start the Telegram bot and internal health server
CMD ["python", "kialent_telegram_bot.py"]
