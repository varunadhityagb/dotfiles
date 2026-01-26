function summarize_dir
    set exclude $argv

    for item in *
        if test -f "$item"
            if _is_included_file_type "$item"
                echo "=================================="
                echo "$item"
                echo "=================================="
                cat "$item"
                echo -e "\n\n"
            end
        end
    end

    for dir in */
        set dir (string trim -c / $dir)
        set skip false

        for ex in $exclude
            if test "$dir" = "$ex"
                set skip true
                break
            end
        end

        if test "$skip" = "false"
            _summarize_recursive "$dir"
        end
    end
end
