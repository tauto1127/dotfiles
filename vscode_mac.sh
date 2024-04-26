# シンボリックリンクの作成
DOT_FILES="keybindings.json settings.json"
CODE_APPS="Code Cursor"
CODE_APP="Code";

echo "シンボリックリンクを作るアプリを選択"
select VAR in $CODE_APPS
do
    echo $VAR
    CODE_APP=$VAR
    break;
done

for file in $DOT_FILES
    do
    if [ -e ~/Library/"Application Support"/$CODE_APP/User/$file ]; then
        echo "$file is already exists"
        echo "overwrite? (y/N): "
        read ans
        if [ "$ans" = "y" ]; then
            rm ~/Library/"Application Support"/$CODE_APP/User/$file
            ln -sf `pwd`/mac/vscode/User/$file ~/Library/"Application Support"/$CODE_APP/User/
        fi
    else
        ln -sf `pwd`/mac/vscode/User/$file ~/Library/"Application Support"/$CODE_APP/User/
    fi
done

echo "success"