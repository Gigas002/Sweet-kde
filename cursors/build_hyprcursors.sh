#!/bin/bash

generate_cursor() {
	local rawsvg="$1"
	local cursor="$2"
	local dir="$3"

	if [ "$dir/$cursor.svg" -ot $rawsvg ] ; then
		echo -ne "\033[0KExporting svg cursor... $cursor\\r"
		inkscape $rawsvg -i $cursor -l -o "$dir/$cursor.svg"
	fi
}

generate_animated_cursor() {
	local rawsvg="$1"
	local cursor="$2"
	local dir="$3"

	# we don't need progress.svg and wait.svg in hyprcursors theme
	rm -f "$dir/$cursor/$cursor.svg"

	for i in {01..23}
	do
		generate_cursor $rawsvg $cursor-$i $dir/$cursor
	done
}

cd "$( dirname "${BASH_SOURCE[0]}" )"
src="src"
raw_svg="$src/cursors.svg"
input_metadata="$src/hyprcursors"
build_base="build_hyprcursors"
build_hyprcursors="$build_base/hyprcursors"

mkdir -p $build_base

# copy metadata files to build directory
cp -R $input_metadata $build_base

# export plain cursors
echo -e "\033[0KExporting svg cursors..."
for cursor_config in $src/config/*.cursor; do
    cursor_name=$(basename "${cursor_config}" .cursor)
    output_path="$build_hyprcursors/hyprcursors/$cursor_name"

	generate_cursor $raw_svg $cursor_name $output_path
done
echo -e "\033[0KExport svg cursor... DONE\\r"

echo -e "\033[0KGenerating animated cursor pixmaps..."
generate_animated_cursor $raw_svg progress $build_hyprcursors/hyprcursors
generate_animated_cursor $raw_svg wait $build_hyprcursors/hyprcursors
echo -e "\033[0KGenerating animated cursor pixmaps... DONE"

echo -e "\033[0KGenerating hyprcursors..."
hyprcursor-util -c $build_hyprcursors > /dev/null
mv -f $build_base/theme_Sweet-cursors-hyprcursor/ Sweet-cursors-hyprcursor/
echo -e "\033[0KGenerating hyprcursors... DONE"

echo "COMPLETE!"
