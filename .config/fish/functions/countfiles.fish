function countfiles
    for t in files links directories
        echo (find . -type (string sub -s 1 -l 1 $t) -printf . 2>/dev/null | wc -c) $t
    end
end
