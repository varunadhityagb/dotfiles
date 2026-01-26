function _is_included_file_type
    if test (count $file_types) -eq 0
        return 0
    end

    for ext in $file_types
        if string match -q "*.$ext" "$argv[1]"
            return 0
        end
    end

    return 1
end
