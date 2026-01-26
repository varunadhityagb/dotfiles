function http_status
    for port in $argv
        curl -s https://http.cat/$port | icat
    end
end
