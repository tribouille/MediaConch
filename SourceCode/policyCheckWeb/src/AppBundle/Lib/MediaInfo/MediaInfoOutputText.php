<?php

namespace AppBundle\Lib\MediaInfo;

class MediaInfoOutputText extends MediaInfoOutputTrack
{
    protected $aliasFields = array();

    public function __construct($xml)
    {
        parent::__construct($xml);
    }
}
