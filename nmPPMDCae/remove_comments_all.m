function remove_comments_all()













    files = dir('*.m');
    for k = 1:numel(files)
        fname = files(k).name;
        fprintf('Processing
        txt = fileread(fname);


        lines = regexp(txt, '\r\n|\n|\r', 'split');

        for i = 1:numel(lines)
            line = lines{i};

            pct = find(line == '
            if ~isempty(pct)
                line = line(1:pct-1);
            end

            line = regexprep(line, '\s+$', '');
            lines{i} = line;
        end


        newtxt = strjoin(lines, sprintf('\n'));


        fid = fopen(fname, 'w');
        if fid < 0
            warning('无法写入文件:
            continue;
        end
        fprintf(fid, '
        fclose(fid);
    end

    fprintf('所有 .m 文件的注释处理完成。\n');
end


