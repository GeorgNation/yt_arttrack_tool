#--------------------------------------------------#
# NotAYTMusic PS Script
#
# This script does makes a video from audio-file
# and picture by using FFMpeg and powershell-taglib.
# This can be used to recreate music album as video
# for simulating YT Music
#
# You will need to install powershell-taglib
# https://github.com/illearth/powershell-taglib
#
# ...and add ffmpeg to enviroment variable "path"
#
# Author: Veselcraft
# Patch: GeorgNation
#
# 2021
#--------------------------------------------------#

Import-Module taglib

$path = Read-Host -Prompt 'Type the path to the album (like D:\music\Autechre\Amber\ )'
$label = Read-Host -Prompt 'Music label a.k.a P-Line (if exists)'
$aggregator = Read-Host -Prompt 'Distributor name'
$filter = '*.mp3'
$files = Get-ChildItem -Path $path -Filter $filter | Where-Object { (-not $_.PSIsContainer) }

$alias = "[NotAYTMusic]"

Echo "$alias Searching for album cover"

$coverfilename = ""

foreach ($cover in Get-ChildItem -Path "$path*" -Include *.jpg, *.jpeg, *.png | Where-Object { (-not $_.PSIsContainer) }){
    $coverfilename = $cover.Name
    Echo "$alias Found $coverfilename!"
}

python topic_thumbnail.py --path "$path$coverfilename"

if([string]::IsNullOrEmpty($coverfilename)){
    Echo "$alias Seems like you don't have any .jpg, .jpeg or .png file to make vid. Exiting."
}else{
    foreach ($filename in $files){
        $media = [TagLib.File]::Create(($path+$filename))
        $title = $media.Tag.Title
        $artist = $media.Tag.Artists
        $album = $media.Tag.Album
        $year = $media.Tag.Year
        if([string]::IsNullOrEmpty($label)) {
            $label = $artist
        }

        $desc = "Provided to YouTube by $aggregator

$title · $artist

$album

℗ $label

Released on: $year

Auto-generated by YouTube."
        Out-File -FilePath "$path$title.txt" -InputObject $desc -Encoding utf8

        Echo "$alias [$title] Description file for description is generated"

        Echo "$alias [$title] Begin to generate the video"

        ffmpeg -loop 1 -y -i $path$coverfilename -i $path$filename -shortest -acodec aac -vcodec h264 "$path$title.mp4"

        Echo "$alias [$title] Done!"
    }
    Echo "$alias Everything is done. Exiting"
}
