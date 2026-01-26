function _summarize_recursive
    for item in $argv[1]/*
        if test -d "$item"
            _summarize_recursive "$item"
        else
            if _is_included_file_type "$item"
                echo "=================================="
                echo "$item"
                echo "=================================="
                cat "$item"
                echo -e "\n\n"
            end
        end
    end
end
