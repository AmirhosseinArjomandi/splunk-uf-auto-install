#!/bin/bash

# Define variables
SPLUNK_PACKAGE="/opt/Script_test/data/splunkforwarder-*.tgz"  # Path to Splunk UF package
INSTALL_DIR="/opt/splunkforwarder"
SPLUNK_USER="YOUR_USERNAME"
SPLUNK_PASS="YOUR_PASSWORD"
SPLUNK_INPUTS="$INSTALL_DIR/etc/system/local/inputs.conf"
SPLUNK_OUTPUTS="$INSTALL_DIR/etc/system/local/outputs.conf"
SPLUNK_CONF="$INSTALL_DIR/etc/splunk-launch.conf"
AUDIT_RULES_SRC="/opt/Script_test/data/audit.rules.txt"  # Path to audit rules file
AUDIT_RULES_DST="/etc/audit/rules.d/audit.rules"
SPLUNK_APPS_DIR="/opt/splunkforwarder/etc/apps"
SPLUNK_APP_TGZ="/opt/Script_test/data/splunk-add-on-for-unix-and-linux.tgz"  # Path to Splunk app

echo " Installing Splunk Universal Forwarder and configuring auditd..."

### Install auditd
echo "Checking and installing auditd..."
if ! command -v auditctl &> /dev/null; then
    if [ -f /etc/debian_version ]; then
        apt update && apt install -y auditd
    elif [ -f /etc/redhat-release ]; then
        yum install -y audit
    fi
else
    echo "auditd is already installed."
fi

### Install Splunk UF
echo "📦 Installing Splunk UF..."
if [ ! -d "$INSTALL_DIR" ]; then
    tar -xvf "$SPLUNK_PACKAGE" -C /opt/
else
    echo "Splunk UF is already installed."
fi

# Set permissions
echo "🔧 Setting permissions..."
chown -R root:root "$INSTALL_DIR"
chmod -R 755 "$INSTALL_DIR"

# Ignore SPLUNK_HOME ownership warnings
echo "⚙Disabling SPLUNK_HOME ownership check..."
echo "SPLUNK_IGNORE_OWNER_CHECK=1" >> "$SPLUNK_CONF"

# Accept Splunk license and enable boot-start
echo " Accepting Splunk license..."
$INSTALL_DIR/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt

### Configure inputs.conf
echo " Configuring Splunk inputs..."
mkdir -p "$(dirname "$SPLUNK_INPUTS")"
cat <<EOL > "$SPLUNK_INPUTS"
"YOUR_CUSTOM_INPUT_CONF"
EOL

### Configure outputs.conf
echo "📡 Configuring Splunk outputs..."
mkdir -p "$(dirname "$SPLUNK_OUTPUTS")"
cat <<EOL > "$SPLUNK_OUTPUTS"
"YOUR_CUSTOM_OUTPUT_CONF"
EOL

### Extract and Move Splunk App
if [ -f "$SPLUNK_APP_TGZ" ]; then
    echo "Extracting Splunk app from TGZ..."
    
    # Ensure /opt/splunkforwarder/etc/apps exists
    if [ ! -d "$SPLUNK_APPS_DIR" ]; then
        echo "Creating Splunk apps directory..."
        mkdir -p "$SPLUNK_APPS_DIR"
    fi

    tar -xvzf "$SPLUNK_APP_TGZ" -C "$SPLUNK_APPS_DIR/"
    chown -R root:root "$SPLUNK_APPS_DIR"
    chmod -R 755 "$SPLUNK_APPS_DIR"
    echo "Splunk app extracted and moved successfully."
else
    echo " Error: Splunk app TGZ file not found"
fi

### Start Splunk UF
echo " Starting Splunk UF..."
$INSTALL_DIR/bin/splunk start --accept-license --no-prompt

### Configure admin credentials
echo " Setting Splunk admin credentials..."
$INSTALL_DIR/bin/splunk edit user admin -password "$SPLUNK_PASS" -role admin -auth admin:$SPLUNK_PASS

### Restart Splunk UF
echo " Restarting Splunk UF..."
$INSTALL_DIR/bin/splunk restart

### Check Splunk UF status
echo "📡 Checking Splunk UF status..."
$INSTALL_DIR/bin/splunk status

echo "Installation completed successfully! (Custom outputs.conf & app moved)"
