<?php

namespace AppBundle\Lib\Checker;

use AppBundle\Lib\MediaInfo\MediaInfo;
use AppBundle\Lib\MediaInfo\MediaInfoOutput;
use AppBundle\Lib\MediaInfo\MediaInfoPolicyChecker;
use AppBundle\Lib\MediaConch\MediaConchPolicy;
use AppBundle\Lib\MediaConch\MediaConchConformance;
use AppBundle\Lib\MediaConch\MediaConchTrace;
use AppBundle\Entity\Policy;

class Checker
{
    private $source;
    private $clientSourceName;
    private $xmlEnable = true;
    private $xml;
    private $conformanceEnable = true;
    private $conformance;
    private $policyEnable = true;
    private $policy;
    private $policyItem;
    private $traceEnable = false;
    private $trace;
    private $traceFormat = array();
    private $status;

    public function __construct($source, $policyItem = false)
    {
        $this->setSource($source);
        if ($policyItem) {
            $this->policyItem = $policyItem;
        }
        else {
            $this->disablePolicy();
        }
    }

    public function run()
    {
        $this->runXml()
            ->runTrace()
            ->runConformance()
            ->runPolicy();
    }

    private function runXml()
    {
        if ($this->xmlEnable) {
            $MediaInfo = new MediaInfo($this->source);
            $MediaInfo->analyse();
            $this->xml = $MediaInfo->getSuccess() ? $MediaInfo->getOutputXml() : false;
        }

        return $this;
    }

    private function runTrace()
    {
        if ($this->traceEnable && count($this->traceFormat) > 0) {
            foreach ($this->traceFormat as $format) {
                $MediaConch = new MediaConchTrace($this->source);
                $MediaConch->run($format);
                $this->trace[$format] = $MediaConch->getSuccess() ? $MediaConch->getOutput() : false;
            }
        }

        return $this;
    }

    private function runConformance()
    {
        if ($this->conformanceEnable) {
            $MediaConch = new MediaConchConformance($this->source);
            $MediaConch->run();
            $this->conformance = $MediaConch->getSuccess() ? $MediaConch->getOutput() : false;
        }

        return $this;
    }

    private function runPolicy()
    {
        if ($this->policyEnable) {
            if ($this->policyItem instanceof Policy) {
                $MediaInfo = new MediaInfo($this->source);
                $MediaInfo->analyse();
                if ($MediaInfo->getSuccess()) {
                    $policyChecker = new MediaInfoPolicyChecker($MediaInfo->getParsedOutput(), $this->policyItem);
                    $policyChecker->check();
                    $this->setStatus($policyChecker->isValid());
                    $this->policy = $policyChecker->getErrors();
                }
            }
            elseif ($this->policyItem instanceof \Symfony\Component\HttpFoundation\File\UploadedFile) {
                $MediaConchPolicy = new MediaConchPolicy($this->source);
                $MediaConchPolicy->setPolicyType($this->policyItem->getClientOriginalExtension())->run($this->policyItem->getRealPath());
                if ($MediaConchPolicy->getSuccess()) {
                    $this->setStatus($MediaConchPolicy->isValid());
                    $this->policy = array($MediaConchPolicy->getOutput());
                }
            }
            else {
                throw new \Exception('policyItem type unknown');
            }
        }

        return $this;
    }

    private function setStatus($status)
    {
        if (false !== $this->status) {
            $this->status = $status;
        }

        return $this;
    }

    public function getStatus()
    {
        return $this->status;
    }

    private function setSource($source)
    {
        if ($source instanceof \Symfony\Component\HttpFoundation\File\UploadedFile) {
            $this->source = $source->getRealPath();
            $this->clientSourceName = $source->getClientOriginalName();
        }
        else {
            $this->source = $source;
        }
    }

    public function getSource()
    {
        if ($this->clientSourceName) {
            return pathinfo($this->clientSourceName, PATHINFO_BASENAME);
        }
        else {
            return pathinfo($this->source, PATHINFO_BASENAME);
        }
    }

    public function enableXml()
    {
        $this->xmlEnable = true;

        return $this;
    }

    public function disableXml()
    {
        $this->xmlEnable = false;

        return $this;
    }

    public function getXml()
    {
        $xml = $this->xml;
        $xml = preg_replace('|<FolderName>(.*)</FolderName>\n|', '', $xml);
        $xml = preg_replace('|<CompleteName>(.*)</CompleteName>\n|', '', $xml);

        if ($this->clientSourceName) {
            return str_replace($this->source, pathinfo($this->clientSourceName, PATHINFO_BASENAME), $xml);
        }
        else {
            return str_replace($this->source, pathinfo($this->source, PATHINFO_BASENAME), $xml);
        }

        return $xml;
    }

    public function enableConformance()
    {
        $this->conformanceEnable = true;

        return $this;
    }

    public function disableConformance()
    {
        $this->conformanceEnable = false;

        return $this;
    }

    public function getConformance()
    {
        if ($this->clientSourceName) {
            return str_replace($this->source, pathinfo($this->clientSourceName, PATHINFO_BASENAME), $this->conformance);
        }
        else {
            return str_replace($this->source, pathinfo($this->source, PATHINFO_BASENAME), $this->conformance);
        }
    }

    public function enablePolicy()
    {
        $this->policyEnable = true;

        return $this;
    }

    public function disablePolicy()
    {
        $this->policyEnable = false;

        return $this;
    }

    public function getPolicy()
    {
        if ($this->policyItem instanceof \Symfony\Component\HttpFoundation\File\UploadedFile) {
            return str_replace($this->policyItem->getRealPath(), $this->policyItem->getClientOriginalName(), $this->policy);
        }
        else {
            return $this->policy;
        }
    }

    public function enableTrace()
    {
        $this->traceEnable = true;

        return $this;
    }

    public function disableTrace()
    {
        $this->traceEnable = false;

        return $this;
    }

    public function setTraceFormat(array $format)
    {
        $this->traceFormat = $format;

        return $this;
    }

    public function addTraceFormat($format)
    {
        if (!in_array($format, $this->traceFormat)) {
            $this->traceFormat[] = $format;
        }

        return $this;
    }

    public function getTrace($format = null)
    {
        if (isset($this->trace['xml'])) {
            if ($this->clientSourceName) {
                $this->trace['xml'] = str_replace($this->source, pathinfo($this->clientSourceName, PATHINFO_BASENAME), $this->trace['xml']);
            }
            else {
                $this->trace['xml'] = str_replace($this->source, pathinfo($this->source, PATHINFO_BASENAME), $this->trace['xml']);
            }
        }

        if (null == $format) {
            return $this->trace;
        }
        else {
            if (isset($this->trace[$format])) {
                return $this->trace[$format];
            }
            else {
                return false;
            }
        }
    }
}
