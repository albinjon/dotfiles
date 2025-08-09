function __complete_terraform
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    
    # Check for terraform in different common locations
    if test -x /opt/homebrew/bin/terraform
        /opt/homebrew/bin/terraform
    else if test -x /usr/bin/terraform
        /usr/bin/terraform
    else if test -x /usr/local/bin/terraform
        /usr/local/bin/terraform
    else
        # Fallback to terraform in PATH
        terraform
    end
end
complete -f -c terraform -a "(__complete_terraform)"
