#!/bin/bash
# 2014-08-30 - v1
# 2017-07-08 - v2 add unified dconf and gconf palette variations

DIR="base16-gnome-terminal"
DEST="../colors/"
# File names
BD_COLOR="bd_color"
BG_COLOR="bg_color"
FG_COLOR="fg_color"
DCONF_PALETTE="palette_dconf"
GCONF_PALETTE="palette_gconf"
UNIFIED_PALETTE="palette"

echo "You maybe want execute \"rm -Rf ../colors/base16-*\" before"

for f in $(ls $DIR/*.sh); do
	file_name=$(basename "$f" .sh)
	mkdir colors/$file_name 2> /dev/null
	# Searching for values
	# Note: '\'' match with a single quote
	#
	# for dconf '',
	dconf_palette=$(sed -rn 's/[ ]*dset palette \"\[{0,1}(.*)\]{0,1}\"/\1/p' $f | sed 's/\]//')	&& [[ -z "$dconf_palette" ]]	&& echo "$file_name: dconf palette not found"
	dconf_bg_color=$(sed -rn 's/[ ]*dset background-color \"(.*)\"/\1/p' $f | sed 's/'\''//g')	&& [[ -z "$dconf_bg_color" ]]	&& echo "$file_name: dconf background-color not found"
	dconf_fg_color=$(sed -rn 's/[ ]*dset foreground-color \"(.*)\"/\1/p' $f | sed 's/'\''//g')	&& [[ -z "$dconf_fg_color" ]]	&& echo "$file_name: dconf foreground-color not found"
	dconf_bd_color=$(sed -rn 's/[ ]*dset bold-color \"(.*)\"/\1/p' $f | sed 's/'\''//g')		&& [[ -z "$dconf_bd_color" ]]	&& echo "$file_name: dconf bold-color not found"
	# for gconf :
	gconf_palette=$(sed -rn 's/[ ]*gset string palette \"(.*)\"/\1/p' $f)				  && [[ -z "$gconf_palette" ]]	&& echo "$file_name: gconf palette not found"
	gconf_bg_color=$(sed -rn 's/[ ]*gset string background_color \"(.*)\"/\1/p' $f | sed 's/'\''//g') && [[ -z "$gconf_bg_color" ]]	&& echo "$file_name: gconf background-color not found"
	gconf_fg_color=$(sed -rn 's/[ ]*gset string foreground_color \"(.*)\"/\1/p' $f | sed 's/'\''//g') && [[ -z "$gconf_fg_color" ]]	&& echo "$file_name: gconf foreground-color not found"
	gconf_bd_color=$(sed -rn 's/[ ]*gset string bold_color \"(.*)\"/\1/p' $f | sed 's/'\''//g')	  && [[ -z "$gconf_bd_color" ]]	&& echo "$file_name: gconf bold-color not found"
	#
	unified_palette="$(echo $gconf_palette | sed 's/\:/\n/g')"

	# write files
	dest_dir="$DEST/$file_name/"
	mkdir $dest_dir 2>/dev/null
	[[ ! -z "$dconf_palette" ]] && echo $dconf_palette > $dest_dir/$DCONF_PALETTE
	[[ ! -z "$gconf_palette" ]] && echo $gconf_palette > $dest_dir/$GCONF_PALETTE
	[[ ! -z "$dconf_bd_color" ]] && echo $dconf_bd_color > $dest_dir/$BD_COLOR
	#echo $gconf_bd_color > $dest_dir/$BD_COLOR # the same
	[[ ! -z "$dconf_bg_color" ]] && echo $dconf_bg_color > $dest_dir/$BG_COLOR
	#echo $gconf_bg_color > $dest_dir/$BG_COLOR # the same
	[[ ! -z "$dconf_fg_color" ]] && echo $dconf_fg_color > $dest_dir/$FG_COLOR
	#echo $gconf_fg_color > $dest_dir/$FG_COLOR # the same
	[[ ! -z "$unified_palette" ]] && echo "$unified_palette" > $dest_dir/$UNIFIED_PALETTE
done

