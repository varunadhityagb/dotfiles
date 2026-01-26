function tscale
    sudo tailscale down
    if test (count $argv) -eq 0
        sudo tailscale up --accept-dns=true --accept-routes=false
    else if test "$argv[1]" = "1"
        sudo tailscale up --accept-dns=true --accept-routes=true
    end
end
