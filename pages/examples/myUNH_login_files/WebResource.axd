function CertMgr(axID, hiddenID, useJava, javaSecurityMode, ChromeWait)
{
    //detect the browser version
    this.BrowserDetect = {
        init: function ()
        {
            this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
            this.version = this.searchVersion(navigator.userAgent)
				 || this.searchVersion(navigator.appVersion)
				 || "an unknown version";
            this.OS = this.searchString(this.dataOS) || "an unknown OS";
        },
        searchString: function (data)
        {
            for (var i = 0; i < data.length; i++)
            {
                var dataString = data[i].string;
                var dataProp = data[i].prop;
                this.versionSearchString = data[i].versionSearch || data[i].identity;
                if (dataString)
                {
                    if (dataString.indexOf(data[i].subString) != -1)
                        return data[i].identity;
                } else if (dataProp)
                    return data[i].identity;
            }
        },
        searchVersion: function (dataString)
        {
            var index = dataString.indexOf(this.versionSearchString);
            if (index == -1)
                return;
            return parseFloat(dataString.substring(index + this.versionSearchString.length + 1));
        },
        dataBrowser: [{
            string: navigator.userAgent,
            subString: "OmniWeb",
            versionSearch: "OmniWeb/",
            identity: "OmniWeb"
        }, {
            string: navigator.userAgent,
            subString: "Android",
            versionSearch: "Android",
            identity: "Android"
        }, {
            string: navigator.vendor,
            subString: "Apple",
            identity: "Safari"
        }, {
            string: navigator.userAgent,
            subString: "Chrome",
            identity: "Chrome"
        }, {
            prop: window.opera,
            identity: "Opera"
        }, {
            string: navigator.vendor,
            subString: "iCab",
            identity: "iCab"
        }, {
            string: navigator.vendor,
            subString: "KDE",
            identity: "Konqueror"
        }, {
            string: navigator.userAgent,
            subString: "Firefox",
            identity: "Firefox"
        }, {
            string: navigator.vendor,
            subString: "Camino",
            identity: "Camino"
        }, { // for newer Netscapes (6+)
            string: navigator.userAgent,
            subString: "Netscape",
            identity: "Netscape"
        }, {
            string: navigator.userAgent,
            subString: "MSIE",
            identity: "Explorer",
            versionSearch: "MSIE"
        }, {
            string: navigator.userAgent,
            subString: "Trident",
            identity: "Explorer"
        }, {
            string: navigator.userAgent,
            subString: "Gecko",
            identity: "Firefox",
            versionSearch: "rv"
        }, { // for older Netscapes (4-)
            string: navigator.userAgent,
            subString: "Mozilla",
            identity: "Netscape",
            versionSearch: "Mozilla"
        }
		],
        dataOS: [{
            string: navigator.platform,
            subString: "Win",
            identity: "Win32"
        }, {
            string: navigator.platform,
            subString: "Mac",
            identity: "Mac"
        },
        //		{ //64bit will always return suse64 --- will check for platform of suse later
        //		    string: navigator.userAgent,
        //		    subString: "SUSE",
        //		    subString:"(x86_64)",
        //		    identity: "Suse64"
        //		},
			{
			string: navigator.userAgent,
			subString: "SUSE",
			identity: "Suse"
			//identity: "Suse32"

}, {
    string: navigator.platform,
    subString: "Linux i686 (x86_64)",
    identity: "Lin64"
}, {
    string: navigator.platform,
    subString: "Linux x86_64",
    identity: "Lin64"
}, {
    string: navigator.platform,
    subString: "Linux",
    identity: "Lin32"
}
		]
    };

    this.BrowserDetect.init();
    this.HiddenID = null;

    try
    {
        this.HiddenElement = document.getElementById(hiddenID);
    } catch (err)
    {
        this.HiddenElement = null;
    }

    if (useJava)
    {
        if (this.BrowserDetect.browser === "Explorer")
        {
            try
            {
                this.ActiveXObject = document.getElementById(axID);
                this.ActiveXObject.SetSecurityMode(javaSecurityMode);
            } catch (err)
            {
                this.ActiveXObject = null;
            }
        } else if (this.BrowserDetect.browser === "Firefox")
        {
            try
            {
                this.FFObject = document.embeds[0];
                this.FFObject.SetSecurityMode(javaSecurityMode);
            } catch (err)
            {
                this.FFObject = null;
            }
        } else if (this.BrowserDetect.browser === "Safari")
        {
            try
            {
                this.SafariObj = document.embeds[0];
                this.SafariObj.SetSecurityMode(javaSecurityMode);
            } catch (err)
            { //alert('safari object error catch');
                this.SafariObj = null;
            }
        } else if (this.BrowserDetect.browser === "Chrome")
        {
            try
            {
                this.ChromeObj = document.embeds[0];
            } catch (err)
            {
                this.ChromeObj = null;
            }
        } else
        {
            try
            {
                this.secureauth = document.embeds[0];
                this.secureauth.SetSecurityMode(javaSecurityMode);
            } catch (err)
            {
                this.secureauth = null;
                //browser does not support java???
            }
        }
    } else
    {
        //alert(this.BrowserDetect.version);
        //alert(this.BrowserDetect.OS);
        try
        {
            this.ActiveXObject = document.getElementById(axID);
        } catch (err)
        {
            this.ActiveXObject = null;
        }
    }

    this.UserID = "";
    this.CompanyID = "";
    this.CRI = "";
    this.SignedCRI = "";
    this.ServerCert = "";
    this.hiddenJRE = "";
    this.CompanyGUID = "";
    this.CompanyName = "";
    this.ApplianceThumbprint = "";
    this.ApplianceName = "";
    this.Context = "";
    this.ExtDC = 0;

    //IPSEC
    this.EnableIPSecProfile = "";
    this.certInstall = "";
    this.PCFProfile = "";
    this.PCFHostName = "";

    //Firefox version and installation path
    this.FFVersion = "";
    this.FFCodePath = "";
    this.Win32FF2 = "";
    this.Win32FF3 = "";
    this.Win32FF4 = "";
    this.Win32FF5 = "";
    this.Lin32FF2 = "";
    this.Lin32FF3 = "";
    this.Lin64FF2 = "";
    this.Lin64FF3 = "";
    this.Suse32FF2 = "";
    this.Suse64FF2 = "";

    this.SafVersion = "";
    //submit button id
    this.btnID = "";

    this.ACTIVEX_NOTFOUND = "NOACTIVEX";
    this.ACTIVEX_FOUND = "ACTIVEX";

    this.ActiveXObjectID = axID;
    this.CheckTimes = 0;
    this.installOptions = "";
    this.certBlob = "";

    this.VerifyBase = function ()
    {
        var result = false;
        try
        {
            if (this.BrowserDetect.browser === "Explorer")
            {
                if (this.ActiveXObject.VerifyInstallation())
                {
                    result = true;
                }
            } else if (this.BrowserDetect.browser === "Firefox")
            {
                if (this.FFObject.VerifyInstallation())
                {
                    result = true;
                }
            } else if (this.BrowserDetect.browser === "Safari")
            {
                if (this.SafariObj.VerifyInstallation())
                {
                    result = true;
                }
            } else if (this.BrowserDetect.browser === "Chrome")
            {
                if (this.ChromeObj.VerifyInstallation())
                {
                    result = true;
                }
            } else if (this.BrowserDetect.browser === "Android")
            {
                if (secureauth.VerifyInstallation())
                {
                    result = true;
                }
            } else
            {
                if (document.secureauth.VerifyInstallation())
                {
                    result = true;
                }
            }
        } catch (err) { }
        return result;
    }

    //Method for installation of Firefox object
    this.InstallXPI = function ()
    {
        if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                var inst = false;
                // Check if the object is initialized and install if not
                if (this.FFObject == null)
                {
                    inst = true;
                }
                // Verify that the object works and check version
                else if (this.FFObject.VerifyInstallation())
                {
                    if (!(this.checkVer()))
                    {
                        inst = true;
                    }
                } else
                {
                    inst = true;
                }
                if (inst)
                {
                    // Install from predefined location

                    var xpi = new Object();
                    xpi["SecurAuth"] = this.FFinstallPath;
                    InstallTrigger.install(xpi);
                }
            } catch (err)
            {
                this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
            }
        }
    }

    this.FFVer = function ()
    {
        //alert(this.BrowserDetect.OS +'||' +this.BrowserDetect.version);
        if (this.BrowserDetect.OS == "Suse" && this.BrowserDetect.version == "2")
        {
            if (useragent.toLowerCase().indexOf("x86_64") >= 0)
            {
                this.BrowserDetect.OS = "Suse64";
                this.FFpath(this.Suse64FF2);
            } else
            {
                this.BrowserDetect.OS = "Suse32";
                this.FFpath(this.Suse32FF2);
            }
        } else if (this.BrowserDetect.OS == "Lin32" && this.BrowserDetect.version == "1.5")
        {
            this.BrowserDetect.version = "2";
            this.FFpath(this.Lin32FF2);
        } else if (this.BrowserDetect.OS == "Lin32" && this.BrowserDetect.version == "2")
        {
            this.FFpath(this.Lin32FF2);
        } else if (this.BrowserDetect.OS == "Lin32" && this.BrowserDetect.version == "3")
        {
            this.FFpath(this.Lin32FF3);
        } else if (this.BrowserDetect.OS == "Lin64" && this.BrowserDetect.version == "1.5")
        {
            this.FFpath(this.Lin64FF2);
        } else if (this.BrowserDetect.OS == "Lin64" && this.BrowserDetect.version == "2")
        {
            this.FFpath(this.Lin64FF2);
        } else if (this.BrowserDetect.OS == "Lin64" && this.BrowserDetect.version == "3")
        {
            this.FFpath(this.Lin64FF3);
        } else if (this.BrowserDetect.OS == "Win32" && this.BrowserDetect.version == "1.5")
        {
            this.FFpath(this.Win32FF2);
        } else if (this.BrowserDetect.OS == "Win32" && this.BrowserDetect.version == "2")
        {
            this.FFpath(this.Win32FF2);
        } else if (this.BrowserDetect.OS == "Win32" && this.BrowserDetect.version == "3")
        {
            this.FFpath(this.Win32FF3);
        } else if (this.BrowserDetect.OS == "Win32" && this.BrowserDetect.version == "4")
        {
            this.FFpath(this.Win32FF4);
        } else if (this.BrowserDetect.OS == "Win32" && this.BrowserDetect.version == "5")
        {
            this.FFpath(this.Win32FF5);
        } else
        {
            if (this.BrowserDetect.OS == "Win32")
                this.FFpath(this.Win32FF5);
            else
                this.FFpath(this.Lin64FF3);
        }
    }

    this.FFinstallPath = "";

    this.FFpath = function (ver)
    {
        this.FFVersion = ver;
        var strArrayVer = ver.toString().split('.');
        var strVer = '';
        for (var i = 0; strArrayVer.length > i; i++)
        {
            if (typeof strArrayVer[i] != 'undefined')
                strVer += strArrayVer[i];
        }
        var browVer = '';
        if (this.BrowserDetect.version == "1.5")
        {
            browVer = "2";
        } else
        {
            var strArraybrowVer = this.BrowserDetect.version.toString().split('.');
            for (var i = 0; strArraybrowVer.length > i; i++)
            {
                if (typeof strArraybrowVer[i] != 'undefined')
                    browVer += strArraybrowVer[i];
            }
        }

        //this.FFinstallPath = this.FFCodePath +'Lin32/FF3/1.0.1/SecureAuthff.cab';
        this.FFinstallPath = this.FFCodePath + this.BrowserDetect.OS + '/FF' + browVer + '/' + strVer + '/SecureAuthFF.cab';
    }

    this.Verify = function ()
    {
        if (this.VerifyBase())
        {
            this.HiddenElement.value = this.ACTIVEX_FOUND;
        } else
        {
            this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
        }
        document.forms[0].submit();
    }

    this.Request = function ()
    {
        if (this.BrowserDetect.browser == "Explorer")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.Context == "")
                    {
                        if (this.ExtDC == "" || this.ExtDC == 0)
                        {
                            this.HiddenElement.value = this.ActiveXObject.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName);
                        } else
                        {
                            this.HiddenElement.value = this.ActiveXObject.CreateCertificateRequestEx2(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context, this.ExtDC);
                        }
                    } else
                    {
                        if (useJava)
                        {
                            this.HiddenElement.value = this.ActiveXObject.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context);
                        } else
                        {
                            if (this.ExtDC == "" || this.ExtDC == 0)
                            {
                                this.HiddenElement.value = this.ActiveXObject.CreateCertificateRequestEx(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context);
                            } else
                            {
                                this.HiddenElement.value = this.ActiveXObject.CreateCertificateRequestEx2(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context, this.ExtDC);
                            }
                        }
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Request caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.Context == "")
                        this.HiddenElement.value = this.FFObject.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName);
                    else
                        this.HiddenElement.value = this.FFObject.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context);
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Request caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Safari")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.Context == "")
                        this.HiddenElement.value = this.SafariObj.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName);
                    else
                        this.HiddenElement.value = this.SafariObj.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context);
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Request caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Chrome")
        {
            try
            {
                if (this.VerifyBase())
                {
                    setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                    if (this.Context == "")
                        this.HiddenElement.value = this.ChromeObj.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName);
                    else
                        this.HiddenElement.value = this.ChromeObj.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context);
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Request caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Android")
        {
            try
            {
                if (this.VerifyBase())
                {
                    this.HiddenElement.value = secureauth.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName);
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Request caught error: " + err.description;
            }
        } else
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.Context = "")
                        this.HiddenElement.value = this.secureauth.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName);
                    else
                        this.HiddenElement.value = this.secureauth.CreateCertificateRequest(this.UserID, this.CompanyID, this.CRI, this.CompanyGUID, this.CompanyName, this.ApplianceThumbprint, this.ApplianceName, this.Context);
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Request caught error: " + err.description;
            }
        }
        document.forms[0].submit();
    }

    this.Install = function ()
    {
        if (this.BrowserDetect.browser == "Explorer")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.EnableIPSecProfile == "True" && this.certInstall == "0")
                    {
                        try
                        {
                            if (useJava)
                            {
                                var rtnVal = this.ActiveXObject.SaveUserCertAndProfile(this.HiddenElement.value, this.certInstall, this.PCFProfile, this.PCFHostName);
                            } else
                            {
                                if (this.Context == "")
                                {
                                    var rtnVal = this.ActiveXObject.SaveUserCertAndProfile(this.HiddenElement.value, this.certInstall, this.PCFProfile, this.PCFHostName);
                                } else
                                {
                                    var rtnVal = this.ActiveXObject.SaveUserCertAndProfileEx(this.HiddenElement.value, this.Context, this.certInstall, this.PCFProfile, this.PCFHostName);
                                }
                            }
                        } catch (err)
                        {
                            //alert(rtnVal); //debug
                        }
                    } else
                    {
                        if (useJava)
                        {
                            this.HiddenElement.value = this.ActiveXObject.SaveUserCertificate(this.HiddenElement.value);
                        } else
                        {
                            if (this.Context == "")
                            {
                                this.HiddenElement.value = this.ActiveXObject.SaveUserCertificate(this.HiddenElement.value);
                            } else
                            {
                                this.HiddenElement.value = this.ActiveXObject.SaveUserCertificateEx(this.HiddenElement.value, this.Context);
                            }
                        }
                        document.forms[0].submit();
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Install caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.EnableIPSecProfile == "True" && this.certInstall == "0")
                    {
                        try
                        {
                            var rtnVal = this.FFObject.SaveUserCertAndProfile(this.HiddenElement.value, this.certInstall, this.PCFProfile, this.PCFHostName);
                        } catch (err)
                        {
                            //alert(this.rtnVal); //debug
                        }
                    } else
                    {
                        this.HiddenElement.value = this.FFObject.SaveUserCertificate(this.HiddenElement.value);
                        document.forms[0].submit();
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Install caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Safari")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.EnableIPSecProfile == "True" && this.certInstall == "0")
                    {
                        try
                        {
                            var rtnVal = this.SafariObj.SaveUserCertAndProfile(this.HiddenElement.value, this.certInstall, this.PCFProfile, this.PCFHostName);
                        } catch (err)
                        {
                            //alert(this.rtnVal);
                        }
                    } else
                    {
                        //alert(this.HiddenElement.value);
                        //this.HiddenElement.value = this.SafariObj.SaveUserCertificate(this.HiddenElement.value);
                        //alert(document.getElementById(this.certBlob).value);

                        this.HiddenElement.value = this.SafariObj.SaveUserCertificate(document.getElementById(this.certBlob).value);
                        document.forms[0].submit();
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                alert(err.Message);
                this.HiddenElement.value = "Install caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Chrome")
        {
            try
            {
                if (this.VerifyBase())
                {
                    try
                    {
                        setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                        this.HiddenElement.value = this.ChromeObj.SaveUserCertificate(this.HiddenElement.value);
                        document.forms[0].submit();
                    } catch (err)
                    {
                        this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                    }
                }
            } catch (err)
            {
                this.HiddenElement.value = "Install caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Android")
        {
            try
            {
                if (this.VerifyBase())
                {
                    try
                    {
                        this.HiddenElement.value = secureauth.SaveUserCertificateExtended(this.HiddenElement.value, this.installOptions);
                        document.forms[0].submit();
                    } catch (err)
                    {
                        this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                    }
                }
            } catch (err)
            {
                this.HiddenElement.value = "Install caught error: " + err.description;
            }
        } else
        {
            try
            {
                if (this.VerifyBase())
                {
                    this.HiddenElement.value = this.secureauth.SaveUserCertificate(this.HiddenElement.value);
                    document.forms[0].submit();
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Install caught error: " + err.description;
            }
        }
        //document.forms[0].submit();
    }

    this.Check = function (submit)
    {
        if (this.BrowserDetect.browser == "Explorer")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (useJava)
                    {
                        this.HiddenElement.value = this.ActiveXObject.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                        //6.1 JRE17 support
                        document.getElementById(this.hiddenJRE).value = this.ActiveXObject.JavaVersion();
                    } else
                    {
                        if (this.Context == "")
                        {
                            this.HiddenElement.value = this.ActiveXObject.GetUserCertificate(this.UserID, this.CompanyID, this.CRI);
                        } else
                        {
                            if (this.ExtDC == "" || this.ExtDC == 0)
                            {
                                this.HiddenElement.value = this.ActiveXObject.GetUserCertificateEx(this.UserID, this.CompanyID, this.CRI, this.Context);
                            } else
                            {
                                this.HiddenElement.value = this.ActiveXObject.GetUserCertificateEx2(this.UserID, this.CompanyID, this.CRI, this.Context, this.ExtDC);
                            }
                        }
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Check caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                if (this.VerifyBase())
                {
                    //if(useJava || !(this.BrowserDetect.OS.search("Lin") >=0 ||(this.BrowserDetect.OS.search("Suse") >=0) ) )
                    if (useJava)
                    {
                        this.HiddenElement.value = this.FFObject.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                        document.getElementById(this.hiddenJRE).value = this.FFObject.JavaVersion();
                    }
                    // FF 3.6 fix - all FF plug-ins requires passing in URL
                    else
                    {
                        this.HiddenElement.value = this.FFObject.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, location.href);
                        // this.HiddenElement.value = this.FFObject.GetUserCertificate(this.UserID,this.CompanyID,this.CRI);
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Check caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Safari")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (useJava)
                    {
                        this.HiddenElement.value = this.SafariObj.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                        document.getElementById(this.hiddenJRE).value = this.SafariObj.JavaVersion();
                    } else
                    {
                        this.HiddenElement.value = this.SafariObj.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, location.href);
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Check caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Chrome")
        {
            try
            {
                if (this.VerifyBase())
                {
                    setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                    this.HiddenElement.value = this.ChromeObj.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                    document.getElementById(this.hiddenJRE).value = this.ChromeObj.JavaVersion();
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Check caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Android")
        {
            try
            {
                if (this.VerifyBase())
                {
                    this.HiddenElement.value = secureauth.GetUserCertificate(this.UserID, this.CompanyID, this.CRI);
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Check caught error: " + err.description;
            }
        } else
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (useJava)
                    {
                        this.HiddenElement.value = this.secureauth.GetUserCertificate(this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                    } else
                    {
                        this.HiddenElement.value = this.secureauth.GetUserCertificate(this.UserID, this.CompanyID, this.CRI);
                    }
                } else
                {
                    this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                }
            } catch (err)
            {
                this.HiddenElement.value = "Check caught error: " + err.description;
            }
        }

        if (useJava && this.HiddenElement.value.indexOf(this.ACTIVEX_NOTFOUND) >= 0 & this.CheckTimes < 5)
        {
            this.CheckTimes += 1;
            this.Check(true);
        } else
        {
            document.forms[0].submit();
        }
    }

    this.InterCert = "";
    this.InstallRoot = function ()
    {
        if (useJava)
        { //for java applet we don't need root cert, so just set the value to 1 to assume there is a root cert installed
            this.HiddenElement.value = 1;
            document.forms[0].submit();
        } else
        {
            var rootInfo = this.HiddenElement.value;
            if (this.BrowserDetect.browser == "Explorer")
            {
                try
                {
                    if (this.VerifyBase())
                    {
                        this.HiddenElement.value = this.ActiveXObject.FindTrRootCert(rootInfo);
                        if (this.HiddenElement.value == 0)
                        {
                            this.HiddenElement.value = this.ActiveXObject.SaveTrRootCert(rootInfo);
                        }
                    } else
                    {
                        this.HiddenElement.value = this.ACTIVEX_NOTFOUND;
                    }
                } catch (err)
                {
                    this.HiddenElement.value = "InstallRoot caught error: " + err.description;
                }
            }
            document.forms[0].submit();
        }
    }

    this.InstallInter = function (interCert)
    {
        if (this.BrowserDetect.browser == "Explorer")
        {
            try
            {
                if (this.VerifyBase())
                {
                    var chkInter = this.ActiveXObject.SaveTrIntermediateCert(interCert);
                }
            } catch (err)
            {
                this.HiddenElement.value = "InstallInter caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Firefox" && (this.BrowserDetect.OS.search("Lin") >= 0))
        {
            try
            {
                if (this.VerifyBase())
                {
                    var chkInter = this.FFObject.FindTrRootCert(interCert);
                    if (chkInter == 0)
                    {
                        chkInter = this.FFObject.SaveTrRootCert(interCert);
                    }
                } else { }
            } catch (err)
            {
                this.HiddenElement.value = "InstallRoot caught error: " + err.description;
            }
        }
    }

    this.EncryptPws = function (passwordTxtControlid)
    {
        if (this.BrowserDetect.browser == "Explorer")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                        this.HiddenElement.value = this.ActiveXObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    else
                        this.HiddenElement.value = this.ActiveXObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                }
            } catch (err)
            {
                this.HiddenElement.value = "EncryptPws caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                        this.HiddenElement.value = this.FFObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    else
                        this.HiddenElement.value = this.FFObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                }
            } catch (err)
            {
                this.HiddenElement.value = "EncryptPws caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Safari")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                        this.HiddenElement.value = this.SafariObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    else
                        this.HiddenElement.value = this.SafariObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                }
            } catch (err)
            {
                this.HiddenElement.value = "EncryptPws caught error: " + err.description;
            }
        } else if (this.BrowserDetect.browser == "Chrome")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                    {
                        setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                        this.HiddenElement.value = this.ChromeObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    } else
                    {
                        setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                        this.HiddenElement.value = this.ChromeObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                    }
                }
            } catch (err)
            {
                this.HiddenElement.value = "EncryptPws caught error: " + err.description;
            }
        }
    }

    this.EncryptCpws = function (passwordTxtControlid, hiddenConfPwsID)
    {
        if (this.BrowserDetect.browser == "Explorer")
        {
            try
            {
                if (this.VerifyBase())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                        document.getElementById(hiddenConfPwsID).value = this.ActiveXObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    else
                        document.getElementById(hiddenConfPwsID).value = this.ActiveXObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                }
            } catch (err)
            {
                document.getElementById(hiddenConfPwsID).value = err.description;
            }
        } else if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                if (this.FFObject.VerifyInstallation())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                        document.getElementById(hiddenConfPwsID).value = this.FFObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    else
                        document.getElementById(hiddenConfPwsID).value = this.FFObject.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                }
            } catch (err)
            {
                document.getElementById(hiddenConfPwsID).value = err.description;
            }
        } else if (this.BrowserDetect.browser == "Safari")
        {
            try
            {
                if (this.SafariObj.VerifyInstallation())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                        document.getElementById(hiddenConfPwsID).value = this.SafariObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    else
                        document.getElementById(hiddenConfPwsID).value = this.SafariObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                }
            } catch (err)
            {
                document.getElementById(hiddenConfPwsID).value = err.description;
            }
        } else if (this.BrowserDetect.browser == "Chrome")
        {
            try
            {
                if (this.ChromeObj.VerifyInstallation())
                {
                    if (this.UserID == "" && this.CompanyID == "")
                    {
                        setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                        document.getElementById(hiddenConfPwsID).value = this.ChromeObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.CRI, this.SignedCRI, this.ServerCert);
                    } else
                    {
                        setTimeout(this.ChromeObj.SetSecurityMode(javaSecurityMode), ChromeWait);
                        document.getElementById(hiddenConfPwsID).value = this.ChromeObj.EncryptPassword(document.getElementById(passwordTxtControlid).value, this.UserID, this.CompanyID, this.CRI, this.SignedCRI, this.ServerCert);
                    }
                }
            } catch (err)
            {
                document.getElementById(hiddenConfPwsID).value = err.description;
            }
        }
    }

    this.ClickThru = function ()
    {
        if (this.BrowserDetect.browser == "Firefox")
        {
            try
            {
                if (this.VerifyBase() && this.checkVer())
                {
                    document.getElementById(this.btnID).click();
                }
            } catch (err)
            {
                //don't autoclick
            }
        } else
        {
            document.getElementById(this.btnID).click();
        }
    }

    this.checkVer = function ()
    {
        if (this.BrowserDetect.browser == "Firefox" && (this.BrowserDetect.OS == "Win32" || (this.BrowserDetect.OS.search("Lin") >= 0) || this.BrowserDetect.OS.search("Suse") >= 0))
        {
            try
            {
                var fVer = this.FFVersion.split('.');
                var objVer = this.FFObject.Version().split('.');
                var ObjstrVer = "";
                var SstrVer = "";
                for (var i = 0; i < objVer.length; i++)
                {
                    SstrVer += this.pad(fVer[i], 3, '0', 1);
                    ObjstrVer += this.pad(objVer[i], 3, '0', 1);
                }
                if (Number(ObjstrVer) < Number(SstrVer))
                {
                    return false;
                } else
                {
                    return true;
                }
            } catch (err)
            {
                return false;
            }
        } else if (this.BrowserDetect.browser == "Safari" && this.BrowserDetect.OS == "Mac")
        {
            var sVer = this.SafVersion.split('.');
            var objVer = this.SafariObj.Version().split('.');
            var ObjstrVer = "";
            var SstrVer = "";
            for (var i = 0; i < objVer.length; i++)
            {
                SstrVer += this.pad(sVer[i], 3, '0', 1);
                ObjstrVer += this.pad(objVer[i], 3, '0', 1);
            }
            if (Number(ObjstrVer) < Number(SstrVer))
            {
                return false;
            } else
            {
                return true;
            }
        }
    }

    this.privateRadio = "";
    this.publicRadio = "";
    this.lblDesc1 = "";
    this.privateNotSupported = "";
    this.supportedBrowser = function ()
    {
        //alert(this.BrowserDetect.browser);
        //alert(this.BrowserDetect.OS);
        // 06/2010 - 5.3.5.2 - JLo - Add Chrome Private Mode support back
        //if (!((this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Win32") ||(this.BrowserDetect.browser == "Explorer" && this.BrowserDetect.OS == "Win32") ||(this.BrowserDetect.browser == "Chrome" && this.BrowserDetect.OS == "Win32")||(this.BrowserDetect.browser == "Safari" && this.BrowserDetect.OS == "Mac") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Lin32") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Lin64") ||(this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS.search("Suse") >=0 ) ))
        //2011.5.5 - 6.0.0.2 move to use javablock.  this line is for native plugin support
        //6.5.1 - Added Chrome to not ever show not supported, primarily to cover ChromeBook with UBC
        if (!((this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Win32") || (this.BrowserDetect.browser == "Explorer" && this.BrowserDetect.OS == "Win32") || (this.BrowserDetect.browser == "Safari" && this.BrowserDetect.OS == "Mac") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Lin32") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Lin64") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS.search("Suse") >= 0) || (this.BrowserDetect.browser == "Chrome")))
        {
            if (useJava)
            { //safari-windows, no FF in Mac
                //if (!( (this.BrowserDetect.browser == "Safari" && this.BrowserDetect.OS == "Win32") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Mac") )  )//&& (this.BrowserDetect.OS.search("Lin") >=0)) ))//|| (this.BrowserDetect.browser == "Opera") ) )
                //add chrome
                if (!((this.BrowserDetect.browser == "Safari" && this.BrowserDetect.OS == "Win32") || (this.BrowserDetect.browser == "Firefox" && this.BrowserDetect.OS == "Mac") || this.BrowserDetect.browser == "Chrome"))
                {
                    if (this.privateRadio.length > 0)
                    {
                        document.getElementById(this.privateRadio).disabled = true;
                    }
                    if (this.publicRadio.length > 0)
                    {
                        document.getElementById(this.publicRadio).checked = true;
                    }
                    document.getElementById(this.lblDesc1).innerHTML = this.privateNotSupported;
                }
            } else
            {
                if (this.privateRadio.length > 0)
                {
                    document.getElementById(this.privateRadio).disabled = true;
                }
                if (this.publicRadio.length > 0)
                {
                    document.getElementById(this.publicRadio).checked = true;
                }
                document.getElementById(this.lblDesc1).innerHTML = this.privateNotSupported;
            }
        }
    }
    this.jreversion = "";
    this.JreNotCurrent = "";
    this.JreNotInstalled = ""
    this.RunInPublic = ""
    this.JavaDetect = function (triggerInstall)
    {
        if (!PluginDetect) {
            var PluginDetect = {
                version: "0.8.5",
                name: "PluginDetect",
                openTag: "<",
                isDefined: function (b) {
                    return typeof b != "undefined"
                },
                isArray: function (b) {
                    return (/array/i).test(Object.prototype.toString.call(b))
                },
                isFunc: function (b) {
                    return typeof b == "function"
                },
                isString: function (b) {
                    return typeof b == "string"
                },
                isNum: function (b) {
                    return typeof b == "number"
                },
                isStrNum: function (b) {
                    return (typeof b == "string" && (/\d/).test(b))
                },
                getNumRegx: /[\d][\d\.\_,\-]*/,
                splitNumRegx: /[\.\_,\-]/g,
                getNum: function (b, c) {
                    var d = this,
                        a = d.isStrNum(b) ? (d.isDefined(c) ? new RegExp(c) : d.getNumRegx).exec(b) : null;
                    return a ? a[0] : null
                },
                compareNums: function (h, f, d) {
                    var e = this,
                        c, b, a, g = parseInt;
                    if (e.isStrNum(h) && e.isStrNum(f)) {
                        if (e.isDefined(d) && d.compareNums) {
                            return d.compareNums(h, f)
                        }
                        c = h.split(e.splitNumRegx);
                        b = f.split(e.splitNumRegx);
                        for (a = 0; a < Math.min(c.length, b.length) ; a++) {
                            if (g(c[a], 10) > g(b[a], 10)) {
                                return 1
                            }
                            if (g(c[a], 10) < g(b[a], 10)) {
                                return -1
                            }
                        }
                    }
                    return 0
                },
                formatNum: function (b, c) {
                    var d = this,
                        a, e;
                    if (!d.isStrNum(b)) {
                        return null
                    }
                    if (!d.isNum(c)) {
                        c = 4
                    }
                    c--;
                    e = b.replace(/\s/g, "").split(d.splitNumRegx).concat(["0", "0", "0", "0"]);
                    for (a = 0; a < 4; a++) {
                        if (/^(0+)(.+)$/.test(e[a])) {
                            e[a] = RegExp.$2
                        }
                        if (a > c || !(/\d/).test(e[a])) {
                            e[a] = "0"
                        }
                    }
                    return e.slice(0, 4).join(",")
                },
                getPROP: function (d, b, a) {
                    var c;
                    try {
                        if (d) {
                            a = d[b]
                        }
                    } catch (c) { }
                    return a
                },
                findNavPlugin: function (l, e, c) {
                    var j = this,
                        h = new RegExp(l, "i"),
                        d = (!j.isDefined(e) || e) ? /\d/ : 0,
                        k = c ? new RegExp(c, "i") : 0,
                        a = navigator.plugins,
                        g = "",
                        f, b, m;
                    for (f = 0; f < a.length; f++) {
                        m = a[f].description || g;
                        b = a[f].name || g;
                        if ((h.test(m) && (!d || d.test(RegExp.leftContext + RegExp.rightContext))) || (h.test(b) && (!d || d.test(RegExp.leftContext + RegExp.rightContext)))) {
                            if (!k || !(k.test(m) || k.test(b))) {
                                return a[f]
                            }
                        }
                    }
                    return null
                },
                getMimeEnabledPlugin: function (k, m, c) {
                    var e = this,
                        f, b = new RegExp(m, "i"),
                        h = "",
                        g = c ? new RegExp(c, "i") : 0,
                        a, l, d, j = e.isString(k) ? [k] : k;
                    for (d = 0; d < j.length; d++) {
                        if ((f = e.hasMimeType(j[d])) && (f = f.enabledPlugin)) {
                            l = f.description || h;
                            a = f.name || h;
                            if (b.test(l) || b.test(a)) {
                                if (!g || !(g.test(l) || g.test(a))) {
                                    return f
                                }
                            }
                        }
                    }
                    return 0
                },
                getVersionDelimiter: ",",
                findPlugin: function (d) {
                    var c = this,
                        b, d, a = {
                            status: -3,
                            plugin: 0
                        };
                    if (c.DOM) {
                        c.DOM.initDiv()
                    }
                    if (!c.isString(d)) {
                        return a
                    }
                    if (d.length == 1) {
                        c.getVersionDelimiter = d;
                        return a
                    }
                    d = d.toLowerCase().replace(/\s/g, "");
                    b = c.Plugins[d];
                    if (!b || !b.getVersion) {
                        return a
                    }
                    a.plugin = b;
                    a.status = 1;
                    return a
                },
                AXO: window.ActiveXObject,
                getAXO: function (a) {
                    var d = null,
                        c, b = this;
                    try {
                        d = new b.AXO(a)
                    } catch (c) { };
                    return d
                },
                browser: {},
                INIT: function () {
                    this.init.library(this)
                },
                init: {
                    $: 1,
                    hasRun: 0,
                    objProperties: function (d, e, b) {
                        var a, c = {};
                        if (e && b) {
                            if (e[b[0]] === 1 && !d.isArray(e) && !d.isFunc(e) && !d.isString(e) && !d.isNum(e)) {
                                for (a = 0; a < b.length; a = a + 2) {
                                    e[b[a]] = b[a + 1];
                                    c[b[a]] = 1
                                }
                            }
                            for (a in e) {
                                if (!c[a] && e[a] && e[a][b[0]] === 1) {
                                    this.objProperties(d, e[a], b)
                                }
                            }
                        }
                    },
                    publicMethods: function (c, f) {
                        var g = this,
                            b = g.$,
                            a, d;
                        if (c && f) {
                            for (a in c) {
                                try {
                                    if (b.isFunc(c[a])) {
                                        f[a] = c[a](f)
                                    }
                                } catch (d) { }
                            }
                        }
                    },
                    plugin: function (a, c) {
                        var d = this,
                            b = d.$;
                        if (a) {
                            d.objProperties(b, a, ["$", b, "$$", a]);
                            if (!b.isDefined(a.getVersionDone)) {
                                a.installed = null;
                                a.version = null;
                                a.version0 = null;
                                a.getVersionDone = null;
                                a.pluginName = c
                            }
                        }
                    },
                    detectIE: function () {
                        var init = this,
                            $ = init.$,
                            browser = $.browser,
                            doc = document,
                            e, x, tmp, userAgent = navigator.userAgent || "",
                            progid, progid1, progid2;
                        tmp = doc.documentMode;
                        try {
                            doc.documentMode = ""
                        } catch (e) { }
                        browser.isIE = $.isNum(doc.documentMode) ? !0 : eval("/*@cc_on!@*/!1");
                        try {
                            doc.documentMode = tmp
                        } catch (e) { };
                        browser.verIE = null;
                        if (browser.isIE) {
                            browser.verIE = doc.documentMode || ((/^(?:.*?[^a-zA-Z])??(?:MSIE|rv\s*\:)\s*(\d+\.?\d*)/i).test(userAgent) ? parseFloat(RegExp.$1, 10) : 7)
                        };
                        browser.ActiveXEnabled = !1;
                        browser.ActiveXFilteringEnabled = !1;
                        if (browser.isIE) {
                            try {
                                browser.ActiveXFilteringEnabled = window.external.msActiveXFilteringEnabled()
                            } catch (e) { }
                            progid1 = ["Msxml2.XMLHTTP", "Msxml2.DOMDocument", "Microsoft.XMLDOM", "TDCCtl.TDCCtl", "Shell.UIHelper", "HtmlDlgSafeHelper.HtmlDlgSafeHelper", "Scripting.Dictionary"];
                            progid2 = ["WMPlayer.OCX", "ShockwaveFlash.ShockwaveFlash", "AgControl.AgControl", ];
                            progid = progid1.concat(progid2);
                            for (x = 0; x < progid.length; x++) {
                                if ($.getAXO(progid[x])) {
                                    browser.ActiveXEnabled = !0;
                                    if (!$.dbug) {
                                        break
                                    }
                                }
                            }
                            if (browser.ActiveXEnabled && browser.ActiveXFilteringEnabled) {
                                for (x = 0; x < progid2.length; x++) {
                                    if ($.getAXO(progid2[x])) {
                                        browser.ActiveXFilteringEnabled = !1;
                                        break
                                    }
                                }
                            }
                        }
                    },
                    detectNonIE: function () {
                        var f = this,
                            d = this.$,
                            a = d.browser,
                            e = navigator,
                            c = a.isIE ? "" : e.userAgent || "",
                            g = e.vendor || "",
                            b = e.product || "";
                        a.isGecko = (/Gecko/i).test(b) && (/Gecko\s*\/\s*\d/i).test(c);
                        a.verGecko = a.isGecko ? d.formatNum((/rv\s*\:\s*([\.\,\d]+)/i).test(c) ? RegExp.$1 : "0.9") : null;
                        a.isChrome = (/(Chrome|CriOS)\s*\/\s*(\d[\d\.]*)/i).test(c);
                        a.verChrome = a.isChrome ? d.formatNum(RegExp.$2) : null;
                        a.isSafari = !a.isChrome && ((/Apple/i).test(g) || !g) && (/Safari\s*\/\s*(\d[\d\.]*)/i).test(c);
                        a.verSafari = a.isSafari && (/Version\s*\/\s*(\d[\d\.]*)/i).test(c) ? d.formatNum(RegExp.$1) : null;
                        a.isOpera = (/Opera\s*[\/]?\s*(\d+\.?\d*)/i).test(c);
                        a.verOpera = a.isOpera && ((/Version\s*\/\s*(\d+\.?\d*)/i).test(c) || 1) ? parseFloat(RegExp.$1, 10) : null
                    },
                    detectPlatform: function () {
                        var e = this,
                            d = e.$,
                            b, a = navigator.platform || "";
                        d.OS = 100;
                        if (a) {
                            var c = ["Win", 1, "Mac", 2, "Linux", 3, "FreeBSD", 4, "iPhone", 21.1, "iPod", 21.2, "iPad", 21.3, "Win.*CE", 22.1, "Win.*Mobile", 22.2, "Pocket\\s*PC", 22.3, "", 100];
                            for (b = c.length - 2; b >= 0; b = b - 2) {
                                if (c[b] && new RegExp(c[b], "i").test(a)) {
                                    d.OS = c[b + 1];
                                    break
                                }
                            }
                        }
                    },
                    library: function (c) {
                        var e = this,
                            d = document,
                            b, a;
                        c.init.objProperties(c, c, ["$", c]);
                        for (a in c.Plugins) {
                            c.init.plugin(c.Plugins[a], a)
                        }
                        e.publicMethods(c.PUBLIC, c);
                        c.win.init();
                        c.head = d.getElementsByTagName("head")[0] || d.getElementsByTagName("body")[0] || d.body || null;
                        e.detectPlatform();
                        e.detectIE();
                        e.detectNonIE();
                        c.init.hasRun = 1
                    }
                },
                ev: {
                    $: 1,
                    handler: function (d, c, b, a) {
                        return function () {
                            d(c, b, a)
                        }
                    },
                    fPush: function (b, a) {
                        var c = this,
                            d = c.$;
                        if (d.isArray(a) && (d.isFunc(b) || (d.isArray(b) && b.length > 0 && d.isFunc(b[0])))) {
                            a.push(b)
                        }
                    },
                    callArray: function (a) {
                        var b = this,
                            d = b.$,
                            c;
                        if (d.isArray(a)) {
                            while (a.length) {
                                c = a[0];
                                a.splice(0, 1);
                                b.call(c)
                            }
                        }
                    },
                    call: function (d) {
                        var b = this,
                            c = b.$,
                            a = c.isArray(d) ? d.length : -1;
                        if (a > 0 && c.isFunc(d[0])) {
                            d[0](c, a > 1 ? d[1] : 0, a > 2 ? d[2] : 0, a > 3 ? d[3] : 0)
                        } else {
                            if (c.isFunc(d)) {
                                d(c)
                            }
                        }
                    }
                },
                PUBLIC: {
                    isMinVersion: function (b) {
                        var a = function (j, h, e, d) {
                            var f = b.findPlugin(j),
                                g, c = -1;
                            if (f.status < 0) {
                                return f.status
                            }
                            g = f.plugin;
                            h = b.formatNum(b.isNum(h) ? h.toString() : (b.isStrNum(h) ? b.getNum(h) : "0"));
                            if (g.getVersionDone != 1) {
                                g.getVersion(h, e, d);
                                if (g.getVersionDone === null) {
                                    g.getVersionDone = 1
                                }
                            }
                            if (g.installed !== null) {
                                c = g.installed <= 0.5 ? g.installed : (g.installed == 0.7 ? 1 : (g.version === null ? 0 : (b.compareNums(g.version, h, g) >= 0 ? 1 : -0.1)))
                            };
                            return c
                        };
                        return a
                    },
                    getVersion: function (b) {
                        var a = function (h, e, d) {
                            var f = b.findPlugin(h),
                                g, c;
                            if (f.status < 0) {
                                return null
                            };
                            g = f.plugin;
                            if (g.getVersionDone != 1) {
                                g.getVersion(null, e, d);
                                if (g.getVersionDone === null) {
                                    g.getVersionDone = 1
                                }
                            }
                            c = (g.version || g.version0);
                            c = c ? c.replace(b.splitNumRegx, b.getVersionDelimiter) : c;
                            return c
                        };
                        return a
                    },
                    getInfo: function (b) {
                        var a = function (h, e, d) {
                            var c = {},
                                f = b.findPlugin(h),
                                g;
                            if (f.status < 0) {
                                return c
                            };
                            g = f.plugin;
                            if (g.getInfo) {
                                if (g.getVersionDone === null) {
                                    b.getVersion ? b.getVersion(h, e, d) : b.isMinVersion(h, "0", e, d)
                                }
                                c = g.getInfo()
                            };
                            return c
                        };
                        return a
                    },
                    onDetectionDone: function (b) {
                        var a = function (j, h, d, c) {
                            var e = b.findPlugin(j),
                                k, g;
                            if (e.status == -3) {
                                return -1
                            }
                            g = e.plugin;
                            if (!b.isArray(g.funcs)) {
                                g.funcs = []
                            };
                            if (g.getVersionDone != 1) {
                                k = b.getVersion ? b.getVersion(j, d, c) : b.isMinVersion(j, "0", d, c)
                            }
                            if (g.installed != -0.5 && g.installed != 0.5) {
                                b.ev.call(h);
                                return 1
                            }
                            b.ev.fPush(h, g.funcs);
                            return 0
                        };
                        return a
                    },
                    hasMimeType: function (b) {
                        var a = function (d) {
                            if (!b.browser.isIE && d && navigator && navigator.mimeTypes) {
                                var g, f, c, e = b.isArray(d) ? d : (b.isString(d) ? [d] : []);
                                for (c = 0; c < e.length; c++) {
                                    if (b.isString(e[c]) && /[^\s]/.test(e[c])) {
                                        g = navigator.mimeTypes[e[c]];
                                        f = g ? g.enabledPlugin : 0;
                                        if (f && (f.name || f.description)) {
                                            return g
                                        }
                                    }
                                }
                            }
                            return null
                        };
                        return a
                    },
                    z: 0
                },
                codebase: {
                    $: 1,
                    isDisabled: function () {
                        var b = this,
                            c = b.$,
                            a = c.browser;
                        return a.ActiveXEnabled && a.isIE && a.verIE >= 7 ? 0 : 1
                    },
                    checkGarbage: function (d) {
                        var b = this,
                            c = b.$,
                            a;
                        if (c.browser.isIE && d && c.getPROP(d.firstChild, "object")) {
                            a = c.getPROP(d.firstChild, "readyState");
                            if (c.isNum(a) && a != 4) {
                                b.garbage = 1;
                                return 1
                            }
                        }
                        return 0
                    },
                    emptyGarbage: function () {
                        var a = this,
                            b = a.$,
                            c;
                        if (b.browser.isIE && a.garbage) {
                            try {
                                window.CollectGarbage()
                            } catch (c) { }
                            a.garbage = 0
                        }
                    },
                    init: function (e) {
                        if (!e.init) {
                            var c = this,
                                d = c.$,
                                a, b;
                            e.init = 1;
                            e.min = 0;
                            e.max = 0;
                            e.hasRun = 0;
                            e.version = null;
                            e.L = 0;
                            e.altHTML = "";
                            e.span = document.createElement("span");
                            e.tagA = '<object width="1" height="1" style="display:none;" codebase="#version=';
                            b = e.classID || e.$$.classID || "";
                            e.tagB = '" ' + ((/clsid\s*:/i).test(b) ? 'classid="' : 'type="') + b + '">' + e.altHTML + d.openTag + "/object>";
                            for (a = 0; a < e.Lower.length; a++) {
                                e.Lower[a] = d.formatNum(e.Lower[a]);
                                e.Upper[a] = d.formatNum(e.Upper[a])
                            }
                        }
                    },
                    isActiveXObject: function (i, b) {
                        var f = this,
                            g = f.$,
                            a = 0,
                            h, d = i.$$,
                            c = i.span;
                        if (i.min && g.compareNums(b, i.min) <= 0) {
                            return 1
                        }
                        if (i.max && g.compareNums(b, i.max) >= 0) {
                            return 0
                        }
                        c.innerHTML = i.tagA + b + i.tagB;
                        if (g.getPROP(c.firstChild, "object")) {
                            a = 1
                        };
                        f.checkGarbage(c);
                        c.innerHTML = "";
                        if (a) {
                            i.min = b
                        } else {
                            i.max = b
                        }
                        return a
                    },
                    convert_: function (f, a, b, e) {
                        var d = f.convert[a],
                            c = f.$;
                        return d ? (c.isFunc(d) ? c.formatNum(d(b.split(c.splitNumRegx), e).join(",")) : b) : d
                    },
                    convert: function (h, c, g) {
                        var e = this,
                            f = h.$,
                            b, a, d;
                        c = f.formatNum(c);
                        a = {
                            v: c,
                            x: -1
                        };
                        if (c) {
                            for (b = 0; b < h.Lower.length; b++) {
                                d = e.convert_(h, b, h.Lower[b]);
                                if (d && f.compareNums(c, g ? d : h.Lower[b]) >= 0 && (!b || f.compareNums(c, g ? e.convert_(h, b, h.Upper[b]) : h.Upper[b]) < 0)) {
                                    a.v = e.convert_(h, b, c, g);
                                    a.x = b;
                                    break
                                }
                            }
                        }
                        return a
                    },
                    isMin: function (g, f) {
                        var d = this,
                            e = g.$,
                            c, b, a = 0;
                        d.init(g);
                        if (!e.isStrNum(f) || d.isDisabled()) {
                            return a
                        };
                        if (!g.L) {
                            g.L = {};
                            for (c = 0; c < g.Lower.length; c++) {
                                if (d.isActiveXObject(g, g.Lower[c])) {
                                    g.L = d.convert(g, g.Lower[c]);
                                    break
                                }
                            }
                        }
                        if (g.L.v) {
                            b = d.convert(g, f, 1);
                            if (b.x >= 0) {
                                a = (g.L.x == b.x ? d.isActiveXObject(g, b.v) : e.compareNums(f, g.L.v) <= 0) ? 1 : -1
                            }
                        };
                        return a
                    },
                    search: function (g) {
                        var k = this,
                            h = k.$,
                            i = g.$$,
                            b = 0,
                            c;
                        k.init(g);
                        c = (g.hasRun || k.isDisabled()) ? 1 : 0;
                        g.hasRun = 1;
                        if (c) {
                            return g.version
                        };
                        var o, n, m, j = function (q, t) {
                            var r = [].concat(f),
                                s;
                            r[q] = t;
                            s = k.isActiveXObject(g, r.join(","));
                            if (s) {
                                b = 1;
                                f[q] = t
                            } else {
                                p[q] = t
                            }
                            return s
                        },
                            d = g.DIGITMAX,
                            e, a, l = 99999999,
                            f = [0, 0, 0, 0],
                            p = [0, 0, 0, 0];
                        for (o = 0; o < p.length; o++) {
                            f[o] = Math.floor(g.DIGITMIN[o]) || 0;
                            e = f.join(",");
                            a = f.slice(0, o).concat([l, l, l, l]).slice(0, f.length).join(",");
                            for (m = 0; m < d.length; m++) {
                                if (h.isArray(d[m])) {
                                    d[m].push(0);
                                    if (d[m][o] > p[o] && h.compareNums(a, g.Lower[m]) >= 0 && h.compareNums(e, g.Upper[m]) < 0) {
                                        p[o] = Math.floor(d[m][o])
                                    }
                                }
                            }
                            for (n = 0; n < 30; n++) {
                                if (p[o] - f[o] <= 16) {
                                    for (m = p[o]; m >= f[o] + (o ? 1 : 0) ; m--) {
                                        if (j(o, m)) {
                                            break
                                        }
                                    }
                                    break
                                }
                                j(o, Math.round((p[o] + f[o]) / 2))
                            }
                            if (!b) {
                                break
                            }
                            p[o] = f[o]
                        }
                        if (b) {
                            g.version = k.convert(g, f.join(",")).v
                        };
                        return g.version
                    }
                },
                win: {
                    $: 1,
                    loaded: false,
                    hasRun: 0,
                    init: function () {
                        var b = this,
                            a = b.$;
                        if (!b.hasRun) {
                            b.hasRun = 1;
                            b.addEvent("load", a.ev.handler(b.runFuncs, a));
                            b.addEvent("unload", a.ev.handler(b.cleanup, a))
                        }
                    },
                    addEvent: function (c, b) {
                        var e = this,
                            d = e.$,
                            a = window;
                        if (d.isFunc(b)) {
                            if (a.addEventListener) {
                                a.addEventListener(c, b, false)
                            } else {
                                if (a.attachEvent) {
                                    a.attachEvent("on" + c, b)
                                } else {
                                    a["on" + c] = e.concatFn(b, a["on" + c])
                                }
                            }
                        }
                    },
                    concatFn: function (d, c) {
                        return function () {
                            d();
                            if (typeof c == "function") {
                                c()
                            }
                        }
                    },
                    funcs0: [],
                    funcs: [],
                    cleanup: function (b) {
                        if (b) {
                            for (var a in b) {
                                b[a] = 0
                            }
                            b = 0
                        }
                    },
                    runFuncs: function (a) {
                        if (a && !a.win.loaded) {
                            a.win.loaded = true;
                            a.ev.callArray(a.win.funcs0);
                            a.ev.callArray(a.win.funcs);
                            if (a.DOM) {
                                a.DOM.onDoneEmptyDiv()
                            }
                        }
                    },
                    z: 0
                },
                DOM: {
                    $: 1,
                    isEnabled: {
                        $: 1,
                        objectTag: function () {
                            var a = this.$;
                            return a.browser.isIE ? a.browser.ActiveXEnabled : 1
                        },
                        objectProperty: function () {
                            var a = this.$;
                            return a.browser.isIE && a.browser.verIE >= 7 ? 1 : 0
                        }
                    },
                    div: null,
                    divID: "plugindetect",
                    divClass: "doNotRemove",
                    divWidth: 50,
                    getDiv: function () {
                        var a = this;
                        return a.div || document.getElementById(a.divID) || null
                    },
                    isDivPermanent: function () {
                        var b = this,
                            c = b.$,
                            a = b.getDiv();
                        return a && c.isString(a.className) && a.className.toLowerCase().indexOf(b.divClass.toLowerCase()) > -1 ? 1 : 0
                    },
                    initDiv: function (b) {
                        var c = this,
                            d = c.$,
                            a;
                        if (!c.div) {
                            a = c.getDiv();
                            if (a) {
                                c.div = a
                            } else {
                                if (b) {
                                    c.div = document.createElement("div");
                                    c.div.id = c.divID
                                }
                            }
                            if (c.div) {
                                c.setStyle(c.div, c.defaultStyle.concat(["display", "block", "width", c.divWidth + "px", "height", (c.pluginSize + 3) + "px", "fontSize", (c.pluginSize + 3) + "px", "lineHeight", (c.pluginSize + 3) + "px"]));
                                if (!a) {
                                    c.setStyle(c.div, ["position", "absolute", "right", "0px", "top", "0px"]);
                                    c.insertDivInBody(c.div)
                                }
                            }
                        }
                    },
                    pluginSize: 1,
                    altHTML: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
                    emptyNode: function (c) {
                        var b = this,
                            d = b.$,
                            a, f;
                        if (c && c.childNodes) {
                            for (a = c.childNodes.length - 1; a >= 0; a--) {
                                if (d.browser.isIE) {
                                    b.setStyle(c.childNodes[a], ["display", "none"])
                                }
                                c.removeChild(c.childNodes[a])
                            }
                        }
                    },
                    LASTfuncs: [],
                    onDoneEmptyDiv: function () {
                        var f = this,
                            g = f.$,
                            b, d, c, a, h;
                        f.initDiv();
                        if (!g.win.loaded || g.win.funcs0.length || g.win.funcs.length) {
                            return
                        }
                        for (b in g.Plugins) {
                            d = g.Plugins[b];
                            if (d) {
                                if (d.OTF == 3 || (d.funcs && d.funcs.length)) {
                                    return
                                }
                            }
                        }
                        g.ev.callArray(f.LASTfuncs);
                        a = f.getDiv();
                        if (a) {
                            if (f.isDivPermanent()) { } else {
                                if (a.childNodes) {
                                    for (b = a.childNodes.length - 1; b >= 0; b--) {
                                        c = a.childNodes[b];
                                        f.emptyNode(c)
                                    }
                                    try {
                                        a.innerHTML = ""
                                    } catch (h) { }
                                }
                                if (a.parentNode) {
                                    try {
                                        a.parentNode.removeChild(a)
                                    } catch (h) { }
                                    a = null;
                                    f.div = null
                                }
                            }
                        }
                    },
                    width: function () {
                        var g = this,
                            e = g.DOM,
                            f = e.$,
                            d = g.span,
                            b, c, a = -1;
                        b = d && f.isNum(d.scrollWidth) ? d.scrollWidth : a;
                        c = d && f.isNum(d.offsetWidth) ? d.offsetWidth : a;
                        return c > 0 ? c : (b > 0 ? b : Math.max(c, b))
                    },
                    obj: function (b) {
                        var d = this,
                            c = d.span,
                            a = c && c.firstChild ? c.firstChild : null;
                        return a
                    },
                    readyState: function () {
                        var b = this,
                            a = b.DOM.$;
                        return a.browser.isIE ? a.getPROP(b.obj(), "readyState") : b.undefined
                    },
                    objectProperty: function () {
                        var d = this,
                            b = d.DOM,
                            c = b.$,
                            a;
                        if (b.isEnabled.objectProperty()) {
                            a = c.getPROP(d.obj(), "object")
                        }
                        return a
                    },
                    getTagStatus: function (b, m, r, p, f, h) {
                        var s = this,
                            d = s.$,
                            q;
                        if (!b || !b.span) {
                            return -2
                        }
                        var k = b.width(),
                            c = b.readyState(),
                            a = b.objectProperty();
                        if (a) {
                            return 1.5
                        }
                        var g = /clsid\s*\:/i,
                            o = r && g.test(r.outerHTML || "") ? r : (p && g.test(p.outerHTML || "") ? p : 0),
                            i = r && !g.test(r.outerHTML || "") ? r : (p && !g.test(p.outerHTML || "") ? p : 0),
                            l = b && g.test(b.outerHTML || "") ? o : i;
                        if (!m || !m.span || !l || !l.span) {
                            return 0
                        }
                        var j = l.width(),
                            n = m.width(),
                            t = l.readyState();
                        if (k < 0 || j < 0 || n <= s.pluginSize) {
                            return 0
                        }
                        if (h && !b.pi && d.isDefined(a) && d.browser.isIE && b.tagName == l.tagName && b.time <= l.time && k === j && c === 0 && t !== 0) {
                            b.pi = 1
                        }
                        if (j < n) {
                            return b.pi ? -0.1 : 0
                        }
                        if (k >= n) {
                            if (!b.winLoaded && d.win.loaded) {
                                return b.pi ? -0.5 : -1
                            }
                            if (d.isNum(f)) {
                                if (!d.isNum(b.count2)) {
                                    b.count2 = f
                                }
                                if (f - b.count2 > 0) {
                                    return b.pi ? -0.5 : -1
                                }
                            }
                        }
                        try {
                            if (k == s.pluginSize && (!d.browser.isIE || c === 4)) {
                                if (!b.winLoaded && d.win.loaded) {
                                    return 1
                                }
                                if (b.winLoaded && d.isNum(f)) {
                                    if (!d.isNum(b.count)) {
                                        b.count = f
                                    }
                                    if (f - b.count >= 5) {
                                        return 1
                                    }
                                }
                            }
                        } catch (q) { }
                        return b.pi ? -0.1 : 0
                    },
                    setStyle: function (b, h) {
                        var c = this,
                            d = c.$,
                            g = b.style,
                            a, f;
                        if (g && h) {
                            for (a = 0; a < h.length; a = a + 2) {
                                try {
                                    g[h[a]] = h[a + 1]
                                } catch (f) { }
                            }
                        }
                    },
                    insertDivInBody: function (a, h) {
                        var j = this,
                            d = j.$,
                            g, b = "pd33993399",
                            c = null,
                            i = h ? window.top.document : window.document,
                            f = i.getElementsByTagName("body")[0] || i.body;
                        if (!f) {
                            try {
                                i.write('<div id="' + b + '">.' + d.openTag + "/div>");
                                c = i.getElementById(b)
                            } catch (g) { }
                        }
                        f = i.getElementsByTagName("body")[0] || i.body;
                        if (f) {
                            f.insertBefore(a, f.firstChild);
                            if (c) {
                                f.removeChild(c)
                            }
                        }
                    },
                    defaultStyle: ["verticalAlign", "baseline", "outlineStyle", "none", "borderStyle", "none", "padding", "0px", "margin", "0px", "visibility", "visible"],
                    insert: function (b, i, g, h, c, q, o) {
                        var s = this,
                            f = s.$,
                            r, t = document,
                            v, m, p = t.createElement("span"),
                            k, a, l = "outline-style:none;border-style:none;padding:0px;margin:0px;visibility:" + (q ? "hidden;" : "visible;") + "display:inline;";
                        if (!f.isDefined(h)) {
                            h = ""
                        }
                        if (f.isString(b) && (/[^\s]/).test(b)) {
                            b = b.toLowerCase().replace(/\s/g, "");
                            v = f.openTag + b + " ";
                            v += 'style="' + l + '" ';
                            var j = 1,
                                u = 1;
                            for (k = 0; k < i.length; k = k + 2) {
                                if (/[^\s]/.test(i[k + 1])) {
                                    v += i[k] + '="' + i[k + 1] + '" '
                                }
                                if ((/width/i).test(i[k])) {
                                    j = 0
                                }
                                if ((/height/i).test(i[k])) {
                                    u = 0
                                }
                            }
                            v += (j ? 'width="' + s.pluginSize + '" ' : "") + (u ? 'height="' + s.pluginSize + '" ' : "");
                            v += ">";
                            for (k = 0; k < g.length; k = k + 2) {
                                if (/[^\s]/.test(g[k + 1])) {
                                    v += f.openTag + 'param name="' + g[k] + '" value="' + g[k + 1] + '" />'
                                }
                            }
                            v += h + f.openTag + "/" + b + ">"
                        } else {
                            b = "";
                            v = h
                        }
                        if (!o) {
                            s.initDiv(1)
                        }
                        var n = o || s.getDiv();
                        m = {
                            span: null,
                            winLoaded: f.win.loaded,
                            tagName: b,
                            outerHTML: v,
                            DOM: s,
                            time: new Date().getTime(),
                            width: s.width,
                            obj: s.obj,
                            readyState: s.readyState,
                            objectProperty: s.objectProperty
                        };
                        if (n && n.parentNode) {
                            s.setStyle(p, s.defaultStyle.concat(["display", "inline"]).concat(o ? [] : ["fontSize", (s.pluginSize + 3) + "px", "lineHeight", (s.pluginSize + 3) + "px"]));
                            n.appendChild(p);
                            try {
                                p.innerHTML = v
                            } catch (r) { };
                            m.span = p;
                            m.winLoaded = f.win.loaded
                        }
                        return m
                    }
                },
                file: {
                    $: 1,
                    any: "fileStorageAny999",
                    valid: "fileStorageValid999",
                    save: function (d, f, c) {
                        var b = this,
                            e = b.$,
                            a;
                        if (d && e.isDefined(c)) {
                            if (!d[b.any]) {
                                d[b.any] = []
                            }
                            if (!d[b.valid]) {
                                d[b.valid] = []
                            }
                            d[b.any].push(c);
                            a = b.split(f, c);
                            if (a) {
                                d[b.valid].push(a)
                            }
                        }
                    },
                    getValidLength: function (a) {
                        return a && a[this.valid] ? a[this.valid].length : 0
                    },
                    getAnyLength: function (a) {
                        return a && a[this.any] ? a[this.any].length : 0
                    },
                    getValid: function (c, a) {
                        var b = this;
                        return c && c[b.valid] ? b.get(c[b.valid], a) : null
                    },
                    getAny: function (c, a) {
                        var b = this;
                        return c && c[b.any] ? b.get(c[b.any], a) : null
                    },
                    get: function (d, a) {
                        var c = d.length - 1,
                            b = this.$.isNum(a) ? a : c;
                        return (b < 0 || b > c) ? null : d[b]
                    },
                    split: function (g, c) {
                        var b = this,
                            e = b.$,
                            f = null,
                            a, d;
                        g = g ? g.replace(".", "\\.") : "";
                        d = new RegExp("^(.*[^\\/])(" + g + "\\s*)$");
                        if (e.isString(c) && d.test(c)) {
                            a = (RegExp.$1).split("/");
                            f = {
                                name: a[a.length - 1],
                                ext: RegExp.$2,
                                full: c
                            };
                            a[a.length - 1] = "";
                            f.path = a.join("/")
                        }
                        return f
                    },
                    z: 0
                },
                Plugins: {
                    java: {
                        $: 1,
                        mimeType: ["application/x-java-applet", "application/x-java-vm", "application/x-java-bean"],
                        mimeType_dummy: "application/dummymimejavaapplet",
                        classID: "clsid:8AD9C840-044E-11D1-B3E9-00805F499D93",
                        classID_dummy: "clsid:8AD9C840-044E-11D1-B3E9-BA9876543210",
                        navigator: {
                            $: 1,
                            a: (function () {
                                var b, a = !0;
                                try {
                                    a = window.navigator.javaEnabled()
                                } catch (b) { }
                                return a
                            })(),
                            javaEnabled: function () {
                                return this.a
                            },
                            mimeObj: 0,
                            pluginObj: 0
                        },
                        OTF: null,
                        info: {
                            $: 1,
                            Plugin2Status: 0,
                            setPlugin2Status: function (a) {
                                if (this.$.isNum(a)) {
                                    this.Plugin2Status = a
                                }
                            },
                            getPlugin2Status: function () {
                                var c = this,
                                    d = c.$,
                                    b = c.$$,
                                    i = b.navigator,
                                    f, g, k, h, j, a;
                                if (c.Plugin2Status === 0) {
                                    if (d.browser.isIE && d.OS == 1 && (/Sun|Oracle/i).test(c.getVendor())) {
                                        f = c.isMinJre4Plugin2();
                                        if (f > 0) {
                                            c.setPlugin2Status(1)
                                        } else {
                                            if (f < 0) {
                                                c.setPlugin2Status(-1)
                                            }
                                        }
                                    } else {
                                        if (!d.browser.isIE && i.pluginObj) {
                                            k = /Next.*Generation.*Java.*Plug-?in|Java.*Plug-?in\s*2\s/i;
                                            h = /Classic.*Java.*Plug-in/i;
                                            j = i.pluginObj.description || "";
                                            a = i.pluginObj.name || "";
                                            if (k.test(j) || k.test(a)) {
                                                c.setPlugin2Status(1)
                                            } else {
                                                if (h.test(j) || h.test(a)) {
                                                    c.setPlugin2Status(-1)
                                                }
                                            }
                                        }
                                    }
                                }
                                return c.Plugin2Status
                            },
                            isMinJre4Plugin2: function (a) {
                                var f = this,
                                    e = f.$,
                                    c = f.$$,
                                    d = "",
                                    g = c.applet.codebase,
                                    b = c.applet.getResult()[0];
                                if (e.OS == 1) {
                                    d = "1,6,0,10"
                                } else {
                                    if (e.OS == 2) {
                                        d = "1,6,0,12"
                                    } else {
                                        if (e.OS == 3) {
                                            d = "1,6,0,10"
                                        } else {
                                            d = "1,6,0,10"
                                        }
                                    }
                                }
                                if (!a) {
                                    a = (b && !c.applet.isRange(b) ? b : 0) || c.version || (g.min && d ? (g.isMin(d) > 0 ? d : "0,0,0,0") : 0)
                                }
                                a = e.formatNum(e.getNum(a));
                                return a ? (e.compareNums(a, d) >= 0 ? 1 : -1) : 0
                            },
                            BrowserForbidsPlugin2: function () {
                                var b = this.$,
                                    a = b.browser;
                                if (b.OS >= 20) {
                                    return 0
                                }
                                if ((a.isIE && a.verIE < 6) || (a.isGecko && b.compareNums(a.verGecko, "1,9,0,0") < 0) || (a.isOpera && a.verOpera && a.verOpera < 10.5)) {
                                    return 1
                                }
                                return 0
                            },
                            BrowserRequiresPlugin2: function () {
                                var b = this.$,
                                    a = b.browser;
                                if (b.OS >= 20) {
                                    return 0
                                }
                                if ((a.isGecko && b.compareNums(a.verGecko, "1,9,2,0") >= 0) || a.isChrome || (b.OS == 1 && a.verOpera && a.verOpera >= 10.6)) {
                                    return 1
                                }
                                return 0
                            },
                            VENDORS: ["Sun Microsystems Inc.", "Apple Computer, Inc.", "Oracle Corporation"],
                            OracleMin: "1,7,0,0",
                            OracleOrSun: function (a) {
                                var c = this,
                                    b = c.$;
                                return c.VENDORS[b.compareNums(b.formatNum(a), c.OracleMin) < 0 ? 0 : 2]
                            },
                            OracleOrApple: function (a) {
                                var c = this,
                                    b = c.$;
                                return c.VENDORS[b.compareNums(b.formatNum(a), c.OracleMin) < 0 ? 1 : 2]
                            },
                            getVendor: function () {
                                var d = this,
                                    c = d.$,
                                    b = d.$$,
                                    f = b.vendor || b.applet.getResult()[1] || "",
                                    e = b.applet.codebase,
                                    a;
                                if (!f) {
                                    a = b.DTK.version || e.version || (e.min ? (e.isMin(d.OracleMin) > 0 ? d.OracleMin : "0,0,0,0") : 0);
                                    if (a) {
                                        f = d.OracleOrSun(a)
                                    } else {
                                        if (b.version) {
                                            if (c.OS == 2) {
                                                f = d.OracleOrApple(b.version)
                                            } else {
                                                if ((!c.browser.isIE && c.OS == 1) || c.OS == 3) {
                                                    f = d.OracleOrSun(b.version)
                                                }
                                            }
                                        }
                                    }
                                }
                                return f
                            },
                            isPlugin2InstalledEnabled: function () {
                                var b = this,
                                    d = b.$,
                                    a = b.$$,
                                    i = -1,
                                    f = a.installed,
                                    g = b.getPlugin2Status(),
                                    h = b.BrowserRequiresPlugin2(),
                                    e = b.BrowserForbidsPlugin2(),
                                    c = b.isMinJre4Plugin2();
                                if (f !== null && f >= -0.1) {
                                    if (g >= 3) {
                                        i = 1
                                    } else {
                                        if (g <= -3) { } else {
                                            if (g == 2) {
                                                i = 1
                                            } else {
                                                if (g == -2) { } else {
                                                    if (h && g >= 0 && c > 0) {
                                                        i = 1
                                                    } else {
                                                        if (e && g <= 0 && c < 0) { } else {
                                                            if (h) {
                                                                i = 1
                                                            } else {
                                                                if (e) { } else {
                                                                    if (g > 0) {
                                                                        i = 1
                                                                    } else {
                                                                        if (g < 0) { } else {
                                                                            if (c < 0) { } else {
                                                                                i = 0
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                return i
                            },
                            result: {
                                $: 1,
                                getDeploymentToolkitObj: function () {
                                    var a = this,
                                        d = a.$,
                                        b = a.$$,
                                        e = b.info,
                                        c = b.DTK;
                                    c.query(1);
                                    e.updateResult();
                                    return c.status && c.HTML ? c.HTML.obj() : c.status
                                }
                            },
                            updateResult: function () {
                                var c = this,
                                    e = c.$,
                                    b = c.$$,
                                    a = b.applet,
                                    i, k = b.installed,
                                    h = b.DTK,
                                    g = a.results,
                                    l = c.result;
                                l.DeployTK_versions = [].concat(e.isArray(h.VERSIONS) ? h.VERSIONS : []);
                                l.vendor = c.getVendor();
                                l.isPlugin2 = c.isPlugin2InstalledEnabled();
                                l.OTF = b.OTF < 3 ? 0 : (b.OTF == 3 ? 1 : 2);
                                l.JavaAppletObj = null;
                                for (i = 0; i < g.length; i++) {
                                    if (g[i][0] && a.HTML[i] && a.HTML[i].obj()) {
                                        l.JavaAppletObj = a.HTML[i].obj();
                                        break
                                    }
                                }
                                var f = [null, null, null, null];
                                for (i = 0; i < g.length; i++) {
                                    if (g[i][0]) {
                                        f[i] = 1
                                    } else {
                                        if (g[i][0] !== null) {
                                            if (b.NOTF) {
                                                b.NOTF.isAppletActive(i)
                                            }
                                            if (a.active[i] > 0) {
                                                f[i] = 0
                                            } else {
                                                if (a.allowed[i] >= 1 && b.OTF != 3 && (a.isDisabled.single(i) || k == -0.2 || k == -1 || a.active[i] < 0 || (i == 3 && (!e.browser.isIE || (/Microsoft/i).test(l.vendor))))) {
                                                    f[i] = -1
                                                }
                                            }
                                        } else {
                                            if (i == 3 && g[0][0]) {
                                                f[i] = 0
                                            } else {
                                                if (a.isDisabled.single(i)) {
                                                    f[i] = -1
                                                }
                                            }
                                        }
                                    }
                                }
                                l.objectTag = f[1];
                                l.appletTag = f[2];
                                l.objectTagActiveX = f[3];
                                l.name = "";
                                l.description = "";
                                var j = 0;
                                if (!e.browser.isIE) {
                                    if (b.navMime.query().pluginObj) {
                                        j = b.navMime.pluginObj
                                    } else {
                                        if (b.navigator.pluginObj) {
                                            j = b.navigator.pluginObj
                                        }
                                    }
                                    if (j) {
                                        l.name = j.name || "";
                                        l.description = j.description || ""
                                    }
                                }
                                l.All_versions = [].concat((l.DeployTK_versions.length ? l.DeployTK_versions : (e.isString(b.version) ? [b.version] : [])));
                                var d = l.All_versions;
                                for (i = 0; i < d.length; i++) {
                                    d[i] = e.formatNum(e.getNum(d[i]))
                                }
                                return l
                            }
                        },
                        getInfo: function () {
                            var a = this.info;
                            a.updateResult();
                            return a.result
                        },
                        getVerifyTagsDefault: function () {
                            return [1, this.applet.isDisabled.VerifyTagsDefault_1() ? 0 : 1, 1]
                        },
                        getVersion: function (j, g, i) {
                            var b = this,
                                d = b.$,
                                e, a = b.applet,
                                h = b.verify,
                                k = b.navigator,
                                f = null,
                                l = null,
                                c = null;
                            if (b.getVersionDone === null) {
                                b.OTF = 0;
                                k.mimeObj = d.hasMimeType(b.mimeType);
                                if (k.mimeObj) {
                                    k.pluginObj = k.mimeObj.enabledPlugin
                                }
                                if (h) {
                                    h.begin()
                                }
                            }
                            a.setVerifyTagsArray(i);
                            d.file.save(b, ".jar", g);
                            if (b.getVersionDone === 0) {
                                if (a.should_Insert_Query_Any()) {
                                    e = a.insert_Query_Any(j);
                                    b.setPluginStatus(e[0], e[1], f, j)
                                }
                                return
                            }
                            if ((!f || d.dbug) && b.navMime.query().version) {
                                f = b.navMime.version
                            }
                            if ((!f || d.dbug) && b.DTK.query(d.dbug).version) {
                                f = b.DTK.version
                            }
                            if ((!f || d.dbug) && b.navPlugin.query().version) {
                                f = b.navPlugin.version
                            }
                            if (b.nonAppletDetectionOk(f)) {
                                c = f
                            }
                            b.setPluginStatus(c, l, f, j);
                            if (a.should_Insert_Query_Any()) {
                                e = a.insert_Query_Any(j);
                                if (e[0]) {
                                    c = e[0];
                                    l = e[1]
                                }
                            }
                            b.setPluginStatus(c, l, f, j)
                        },
                        nonAppletDetectionOk: function (b) {
                            var d = this,
                                e = d.$,
                                a = d.navigator,
                                c = 1;
                            if (!b || !a.javaEnabled() || (!e.browser.isIE && !a.mimeObj) || (e.browser.isIE && !e.browser.ActiveXEnabled)) {
                                c = 0
                            } else {
                                if (e.OS >= 20) { } else {
                                    if (d.info && d.info.getPlugin2Status() < 0 && d.info.BrowserRequiresPlugin2()) {
                                        c = 0
                                    }
                                }
                            }
                            return c
                        },
                        setPluginStatus: function (d, i, g, h) {
                            var b = this,
                                e = b.$,
                                f, c = 0,
                                a = b.applet;
                            g = g || b.version0;
                            f = a.isRange(d);
                            if (f) {
                                if (a.setRange(f, h) == d) {
                                    c = f
                                }
                                d = 0
                            }
                            if (b.OTF < 3) {
                                b.installed = c ? (c > 0 ? 0.7 : -0.1) : (d ? 1 : (g ? -0.2 : -1))
                            }
                            if (b.OTF == 2 && b.NOTF && !b.applet.getResult()[0]) {
                                b.installed = g ? -0.2 : -1
                            }
                            if (b.OTF == 3 && b.installed != -0.5 && b.installed != 0.5) {
                                b.installed = (b.NOTF.isJavaActive(1) == 1 ? 0.5 : -0.5)
                            }
                            if (b.OTF == 4 && (b.installed == -0.5 || b.installed == 0.5)) {
                                if (d) {
                                    b.installed = 1
                                } else {
                                    if (c) {
                                        b.installed = c > 0 ? 0.7 : -0.1
                                    } else {
                                        if (b.NOTF.isJavaActive(1) == 1) {
                                            if (g) {
                                                b.installed = 1;
                                                d = g
                                            } else {
                                                b.installed = 0
                                            }
                                        } else {
                                            if (g) {
                                                b.installed = -0.2
                                            } else {
                                                b.installed = -1
                                            }
                                        }
                                    }
                                }
                            }
                            if (g) {
                                b.version0 = e.formatNum(e.getNum(g))
                            }
                            if (d && !c) {
                                b.version = e.formatNum(e.getNum(d))
                            }
                            if (i && e.isString(i)) {
                                b.vendor = i
                            }
                            if (!b.vendor) {
                                b.vendor = ""
                            }
                            if (b.verify && b.verify.isEnabled()) {
                                b.getVersionDone = 0
                            } else {
                                if (b.getVersionDone != 1) {
                                    if (b.OTF < 2) {
                                        b.getVersionDone = 0
                                    } else {
                                        b.getVersionDone = b.applet.can_Insert_Query_Any() ? 0 : 1
                                    }
                                }
                            };
                            e.codebase.emptyGarbage()
                        },
                        DTK: {
                            $: 1,
                            hasRun: 0,
                            status: null,
                            VERSIONS: [],
                            version: "",
                            HTML: null,
                            Plugin2Status: null,
                            classID: ["clsid:CAFEEFAC-DEC7-0000-0001-ABCDEFFEDCBA", "clsid:CAFEEFAC-DEC7-0000-0000-ABCDEFFEDCBA"],
                            mimeType: ["application/java-deployment-toolkit", "application/npruntime-scriptable-plugin;DeploymentToolkit"],
                            isDisabled: function (a) {
                                var c = this,
                                    d = c.$,
                                    b = d.browser;
                                if (!a && (!d.DOM.isEnabled.objectTag() || (b.isIE && b.verIE < 6) || (b.isGecko && d.compareNums(b.verGecko, d.formatNum("1.6")) <= 0) || (b.isSafari && d.OS == 1 && (!b.verSafari || d.compareNums(b.verSafari, "5,1,0,0") < 0)) || b.isChrome)) {
                                    return 1
                                }
                                return 0
                            },
                            query: function (n) {
                                var l = this,
                                    h = l.$,
                                    f = l.$$,
                                    k, m, i, a = h.DOM.altHTML,
                                    g = {},
                                    b, d = null,
                                    j = null,
                                    c = (l.hasRun || l.isDisabled(n));
                                l.hasRun = 1;
                                if (c) {
                                    return l
                                }
                                l.status = 0;
                                if (h.browser.isIE) {
                                    for (m = 0; m < l.classID.length; m++) {
                                        l.HTML = h.DOM.insert("object", ["classid", l.classID[m]], [], a);
                                        d = l.HTML.obj();
                                        if (h.getPROP(d, "jvms")) {
                                            break
                                        }
                                    }
                                } else {
                                    i = h.hasMimeType(l.mimeType);
                                    if (i && i.type) {
                                        l.HTML = h.DOM.insert("object", ["type", i.type], [], a);
                                        d = l.HTML.obj()
                                    }
                                }
                                if (d) {
                                    try {
                                        if (Math.abs(f.info.getPlugin2Status()) < 2) {
                                            l.Plugin2Status = d.isPlugin2()
                                        }
                                    } catch (k) { }
                                    if (l.Plugin2Status !== null) {
                                        if (l.Plugin2Status) {
                                            f.info.setPlugin2Status(2)
                                        } else {
                                            if (h.browser.isIE || f.info.getPlugin2Status() <= 0) {
                                                f.info.setPlugin2Status(-2)
                                            }
                                        }
                                    }
                                    try {
                                        b = h.getPROP(d, "jvms");
                                        if (b) {
                                            j = b.getLength();
                                            if (h.isNum(j)) {
                                                l.status = j > 0 ? 1 : -1;
                                                for (m = 0; m < j; m++) {
                                                    i = h.getNum(b.get(j - 1 - m).version);
                                                    if (i) {
                                                        l.VERSIONS.push(i);
                                                        g["a" + h.formatNum(i)] = 1
                                                    }
                                                }
                                            }
                                        }
                                    } catch (k) { }
                                }
                                i = 0;
                                for (m in g) {
                                    i++
                                }
                                if (i && i !== l.VERSIONS.length) {
                                    l.VERSIONS = []
                                }
                                if (l.VERSIONS.length) {
                                    l.version = h.formatNum(l.VERSIONS[0])
                                };
                                return l
                            }
                        },
                        navMime: {
                            $: 1,
                            hasRun: 0,
                            mimetype: "",
                            version: "",
                            length: 0,
                            mimeObj: 0,
                            pluginObj: 0,
                            isDisabled: function () {
                                var b = this,
                                    d = b.$,
                                    c = b.$$,
                                    a = c.navigator;
                                if (d.browser.isIE || !a.mimeObj || !a.pluginObj) {
                                    return 1
                                }
                                return 0
                            },
                            query: function () {
                                var i = this,
                                    f = i.$,
                                    a = i.$$,
                                    b = (i.hasRun || i.isDisabled());
                                i.hasRun = 1;
                                if (b) {
                                    return i
                                };
                                var n = /^\s*application\/x-java-applet;jpi-version\s*=\s*(\d.*)$/i,
                                    g, l, j, d = "",
                                    h = "a",
                                    o, m, k = {},
                                    c = f.formatNum("0");
                                for (l = 0; l < navigator.mimeTypes.length; l++) {
                                    o = navigator.mimeTypes[l];
                                    m = o ? o.enabledPlugin : 0;
                                    g = o && n.test(o.type || d) ? f.formatNum(f.getNum(RegExp.$1)) : 0;
                                    if (g && m && (m.description || m.name)) {
                                        if (!k[h + g]) {
                                            i.length++
                                        }
                                        k[h + g] = o.type;
                                        if (f.compareNums(g, c) > 0) {
                                            c = g
                                        }
                                    }
                                }
                                g = k[h + c];
                                if (g) {
                                    o = f.hasMimeType(g);
                                    i.mimeObj = o;
                                    i.pluginObj = o ? o.enabledPlugin : 0;
                                    i.mimetype = g;
                                    i.version = c
                                };
                                return i
                            }
                        },
                        navPlugin: {
                            $: 1,
                            hasRun: 0,
                            version: "",
                            isDisabled: function () {
                                var d = this,
                                    c = d.$,
                                    b = d.$$,
                                    a = b.navigator;
                                if (c.browser.isIE || !a.mimeObj || !a.pluginObj) {
                                    return 1
                                }
                                return 0
                            },
                            query: function () {
                                var m = this,
                                    e = m.$,
                                    c = m.$$,
                                    h = c.navigator,
                                    j, l, k, g, d, a, i, f = 0,
                                    b = (m.hasRun || m.isDisabled());
                                m.hasRun = 1;
                                if (b) {
                                    return m
                                };
                                a = h.pluginObj.name || "";
                                i = h.pluginObj.description || "";
                                if (!f || e.dbug) {
                                    g = /Java.*TM.*Platform[^\d]*(\d+)(?:[\.,_](\d*))?(?:\s*[Update]+\s*(\d*))?/i;
                                    if ((g.test(a) || g.test(i)) && parseInt(RegExp.$1, 10) >= 5) {
                                        f = "1," + RegExp.$1 + "," + (RegExp.$2 ? RegExp.$2 : "0") + "," + (RegExp.$3 ? RegExp.$3 : "0")
                                    }
                                }
                                if (!f || e.dbug) {
                                    g = /Java[^\d]*Plug-in/i;
                                    l = g.test(i) ? e.formatNum(e.getNum(i)) : 0;
                                    k = g.test(a) ? e.formatNum(e.getNum(a)) : 0;
                                    if (l && (e.compareNums(l, e.formatNum("1,3")) < 0 || e.compareNums(l, e.formatNum("2")) >= 0)) {
                                        l = 0
                                    }
                                    if (k && (e.compareNums(k, e.formatNum("1,3")) < 0 || e.compareNums(k, e.formatNum("2")) >= 0)) {
                                        k = 0
                                    }
                                    d = l && k ? (e.compareNums(l, k) > 0 ? l : k) : (l || k);
                                    if (d) {
                                        f = d
                                    }
                                }
                                if (!f && e.browser.isSafari && e.OS == 2) {
                                    j = e.findNavPlugin("Java.*\\d.*Plug-in.*Cocoa", 0);
                                    if (j) {
                                        l = e.getNum(j.description);
                                        if (l) {
                                            f = l
                                        }
                                    }
                                };
                                if (f) {
                                    m.version = e.formatNum(f)
                                };
                                return m
                            }
                        },
                        applet: {
                            $: 1,
                            codebase: {
                                $: 1,
                                isMin: function (a) {
                                    return this.$.codebase.isMin(this, a)
                                },
                                search: function () {
                                    return this.$.codebase.search(this)
                                },
                                ParamTags: '<param name="code" value="A19999.class" /><param name="codebase_lookup" value="false" />',
                                DIGITMAX: [
                                    [16, 64],
                                    [6, 0, 512], 0, [1, 5, 2, 256], 0, [1, 4, 1, 1],
                                    [1, 4, 0, 64],
                                    [1, 3, 2, 32]
                                ],
                                DIGITMIN: [1, 0, 0, 0],
                                Upper: ["999", "10", "5,0,20", "1,5,0,20", "1,4,1,20", "1,4,1,2", "1,4,1", "1,4"],
                                Lower: ["10", "5,0,20", "1,5,0,20", "1,4,1,20", "1,4,1,2", "1,4,1", "1,4", "0"],
                                convert: [function (b, a) {
                                    return a ? [parseInt(b[0], 10) > 1 ? "99" : parseInt(b[1], 10) + 3 + "", b[3], "0", "0"] : ["1", parseInt(b[0], 10) - 3 + "", "0", b[1]]
                                }, function (b, a) {
                                    return a ? [b[1], b[2], b[3] + "0", "0"] : ["1", b[0], b[1], b[2].substring(0, b[2].length - 1 || 1)]
                                }, 0, function (b, a) {
                                    return a ? [b[0], b[1], b[2], b[3] + "0"] : [b[0], b[1], b[2], b[3].substring(0, b[3].length - 1 || 1)]
                                }, 0, 1, function (b, a) {
                                    return a ? [b[0], b[1], b[2], b[3] + "0"] : [b[0], b[1], b[2], b[3].substring(0, b[3].length - 1 || 1)]
                                }, 1]
                            },
                            results: [
                                [null, null],
                                [null, null],
                                [null, null],
                                [null, null]
                            ],
                            getResult: function () {
                                var b = this,
                                    d = b.results,
                                    a, c = [];
                                for (a = d.length - 1; a >= 0; a--) {
                                    c = d[a];
                                    if (c[0]) {
                                        break
                                    }
                                }
                                c = [].concat(c);
                                return c
                            },
                            DummySpanTagHTML: 0,
                            HTML: [0, 0, 0, 0],
                            active: [0, 0, 0, 0],
                            DummyObjTagHTML: 0,
                            DummyObjTagHTML2: 0,
                            allowed: [1, 1, 1, 1],
                            VerifyTagsHas: function (c) {
                                var d = this,
                                    b;
                                for (b = 0; b < d.allowed.length; b++) {
                                    if (d.allowed[b] === c) {
                                        return 1
                                    }
                                }
                                return 0
                            },
                            saveAsVerifyTagsArray: function (c) {
                                var b = this,
                                    d = b.$,
                                    a;
                                if (d.isArray(c)) {
                                    for (a = 1; a < b.allowed.length; a++) {
                                        if (c.length > a - 1 && d.isNum(c[a - 1])) {
                                            if (c[a - 1] < 0) {
                                                c[a - 1] = 0
                                            }
                                            if (c[a - 1] > 3) {
                                                c[a - 1] = 3
                                            }
                                            b.allowed[a] = c[a - 1]
                                        }
                                    }
                                    b.allowed[0] = b.allowed[3]
                                }
                            },
                            setVerifyTagsArray: function (d) {
                                var b = this,
                                    c = b.$,
                                    a = b.$$;
                                if (a.getVersionDone === null) {
                                    b.saveAsVerifyTagsArray(a.getVerifyTagsDefault())
                                }
                                if (c.dbug) {
                                    b.saveAsVerifyTagsArray([3, 3, 3])
                                } else {
                                    if (d) {
                                        b.saveAsVerifyTagsArray(d)
                                    }
                                }
                            },
                            isDisabled: {
                                $: 1,
                                single: function (d) {
                                    var a = this,
                                        c = a.$,
                                        b = a.$$;
                                    if (d == 0) {
                                        return c.codebase.isDisabled()
                                    }
                                    if ((d == 3 && !c.browser.isIE) || a.all()) {
                                        return 1
                                    }
                                    if (d == 1 || d == 3) {
                                        return !c.DOM.isEnabled.objectTag()
                                    }
                                    if (d == 2) {
                                        return a.AppletTag()
                                    }
                                },
                                aA_: null,
                                all: function () {
                                    var c = this,
                                        f = c.$,
                                        e = c.$$,
                                        b = e.navigator,
                                        a = 0,
                                        d = f.browser;
                                    if (c.aA_ === null) {
                                        if (f.OS >= 20) {
                                            a = 0
                                        } else {
                                            if (d.verOpera && d.verOpera < 11 && !b.javaEnabled()) {
                                                a = 1
                                            } else {
                                                if ((d.verGecko && f.compareNums(d.verGecko, f.formatNum("2")) < 0) && !b.mimeObj) {
                                                    a = 1
                                                } else {
                                                    if (c.AppletTag() && !f.DOM.isEnabled.objectTag()) {
                                                        a = 1
                                                    }
                                                }
                                            }
                                        };
                                        c.aA_ = a
                                    }
                                    return c.aA_
                                },
                                AppletTag: function () {
                                    var b = this,
                                        d = b.$,
                                        c = b.$$,
                                        a = c.navigator;
                                    return d.browser.isIE ? !a.javaEnabled() : 0
                                },
                                VerifyTagsDefault_1: function () {
                                    var b = this.$,
                                        a = b.browser;
                                    if (b.OS >= 20) {
                                        return 1
                                    }
                                    if ((a.isIE && (a.verIE < 9 || !a.ActiveXEnabled)) || (a.verGecko && b.compareNums(a.verGecko, b.formatNum("2")) < 0) || (a.isSafari && (!a.verSafari || b.compareNums(a.verSafari, b.formatNum("4")) < 0)) || (a.verOpera && a.verOpera < 10)) {
                                        return 0
                                    }
                                    return 1
                                },
                                z: 0
                            },
                            can_Insert_Query: function (d) {
                                var b = this,
                                    c = b.results[0][0],
                                    a = b.getResult()[0];
                                if (b.HTML[d] || (d == 0 && c !== null && !b.isRange(c)) || (d == 0 && a && !b.isRange(a))) {
                                    return 0
                                }
                                return !b.isDisabled.single(d)
                            },
                            can_Insert_Query_Any: function () {
                                var b = this,
                                    a;
                                for (a = 0; a < b.results.length; a++) {
                                    if (b.can_Insert_Query(a)) {
                                        return 1
                                    }
                                }
                                return 0
                            },
                            should_Insert_Query: function (e) {
                                var c = this,
                                    f = c.allowed,
                                    d = c.$,
                                    b = c.$$,
                                    a = c.getResult()[0];
                                a = a && (e > 0 || !c.isRange(a));
                                if (!c.can_Insert_Query(e) || f[e] === 0) {
                                    return 0
                                }
                                if (f[e] == 3 || (f[e] == 2.8 && !a)) {
                                    return 1
                                }
                                if (!b.nonAppletDetectionOk(b.version0)) {
                                    if (f[e] == 2 || (f[e] == 1 && !a)) {
                                        return 1
                                    }
                                }
                                return 0
                            },
                            should_Insert_Query_Any: function () {
                                var b = this,
                                    a;
                                for (a = 0; a < b.allowed.length; a++) {
                                    if (b.should_Insert_Query(a)) {
                                        return 1
                                    }
                                }
                                return 0
                            },
                            query: function (f) {
                                var j, a = this,
                                    i = a.$,
                                    d = a.$$,
                                    k = null,
                                    l = null,
                                    b = a.results,
                                    c, h, g = a.HTML[f];
                                if (!g || !g.obj() || b[f][0] || d.bridgeDisabled || (i.dbug && d.OTF < 3)) {
                                    return
                                }
                                c = g.obj();
                                h = g.readyState();
                                if (1) {
                                    try {
                                        k = i.getNum(c.getVersion() + "");
                                        l = c.getVendor() + "";
                                        c.statusbar(i.win.loaded ? " " : " ")
                                    } catch (j) { };
                                    if (k && i.isStrNum(k)) {
                                        b[f] = [k, l];
                                        a.active[f] = 2
                                    }
                                }
                            },
                            isRange: function (a) {
                                return (/^[<>]/).test(a || "") ? (a.charAt(0) == ">" ? 1 : -1) : 0
                            },
                            setRange: function (b, a) {
                                return (b ? (b > 0 ? ">" : "<") : "") + (this.$.isString(a) ? a : "")
                            },
                            insertJavaTag: function (g, n, h, o, m) {
                                var e = this,
                                    c = e.$,
                                    k = e.$$,
                                    r = "A.class",
                                    b = c.file.getValid(k),
                                    f = b.name + b.ext,
                                    q = b.path;
                                var i = ["archive", f, "code", r],
                                    l = (o ? ["width", o] : []).concat(m ? ["height", m] : []),
                                    j = ["mayscript", "true"],
                                    p = ["scriptable", "true", "codebase_lookup", "false"].concat(j),
                                    a = k.navigator,
                                    d = !c.browser.isIE && a.mimeObj && a.mimeObj.type ? a.mimeObj.type : k.mimeType[0];
                                if (g == 1) {
                                    return c.browser.isIE ? c.DOM.insert("object", ["type", d].concat(l), ["codebase", q].concat(i).concat(p), h, k, 0, n) : c.DOM.insert("object", ["type", d].concat(l), ["codebase", q].concat(i).concat(p), h, k, 0, n)
                                }
                                if (g == 2) {
                                    return c.browser.isIE ? c.DOM.insert("applet", ["alt", h].concat(j).concat(i).concat(l), ["codebase", q].concat(p), h, k, 0, n) : c.DOM.insert("applet", ["codebase", q, "alt", h].concat(j).concat(i).concat(l), [].concat(p), h, k, 0, n)
                                }
                                if (g == 3) {
                                    return c.browser.isIE ? c.DOM.insert("object", ["classid", k.classID].concat(l), ["codebase", q].concat(i).concat(p), h, k, 0, n) : c.DOM.insert()
                                }
                                if (g == 4) {
                                    return c.DOM.insert("embed", ["codebase", q].concat(i).concat(["type", d]).concat(p).concat(l), [], h, k, 0, n)
                                }
                            },
                            insert_Query_Any: function (i) {
                                var b = this,
                                    d = b.$,
                                    c = b.$$,
                                    g = b.results,
                                    j = b.HTML,
                                    a = d.DOM.altHTML,
                                    e, h = d.file.getValid(c);
                                if (b.should_Insert_Query(0)) {
                                    if (c.OTF < 2) {
                                        c.OTF = 2
                                    };
                                    g[0] = [0, 0];
                                    e = i ? b.codebase.isMin(i) : b.codebase.search();
                                    if (e) {
                                        g[0][0] = i ? b.setRange(e, i) : e
                                    }
                                    b.active[0] = e ? 1.5 : -1
                                }
                                if (!h) {
                                    return b.getResult()
                                }
                                if (!b.DummySpanTagHTML) {
                                    b.DummySpanTagHTML = d.DOM.insert("", [], [], a)
                                }
                                if (b.should_Insert_Query(1)) {
                                    if (c.OTF < 2) {
                                        c.OTF = 2
                                    };
                                    j[1] = b.insertJavaTag(1, 0, a);
                                    g[1] = [0, 0];
                                    b.query(1)
                                }
                                if (b.should_Insert_Query(2)) {
                                    if (c.OTF < 2) {
                                        c.OTF = 2
                                    };
                                    j[2] = b.insertJavaTag(2, 0, a);
                                    g[2] = [0, 0];
                                    b.query(2)
                                }
                                if (b.should_Insert_Query(3)) {
                                    if (c.OTF < 2) {
                                        c.OTF = 2
                                    };
                                    j[3] = b.insertJavaTag(3, 0, a);
                                    g[3] = [0, 0];
                                    b.query(3)
                                }
                                if (d.DOM.isEnabled.objectTag()) {
                                    if (!b.DummyObjTagHTML && (j[1] || j[2])) {
                                        b.DummyObjTagHTML = d.DOM.insert("object", ["type", c.mimeType_dummy], [], a)
                                    }
                                    if (!b.DummyObjTagHTML2 && j[3]) {
                                        b.DummyObjTagHTML2 = d.DOM.insert("object", ["classid", c.classID_dummy], [], a)
                                    }
                                }
                                var f = c.NOTF;
                                if (c.OTF < 3 && f.shouldContinueQuery()) {
                                    c.OTF = 3;
                                    f.onIntervalQuery = d.ev.handler(f.$$onIntervalQuery, f);
                                    if (!d.win.loaded) {
                                        d.win.funcs0.push([f.winOnLoadQuery, f])
                                    }
                                    setTimeout(f.onIntervalQuery, f.intervalLength)
                                }
                                return b.getResult()
                            }
                        },
                        NOTF: {
                            $: 1,
                            count: 0,
                            countMax: 25,
                            intervalLength: 250,
                            shouldContinueQuery: function () {
                                var f = this,
                                    e = f.$,
                                    c = f.$$,
                                    b = c.applet,
                                    a, d = 0;
                                if (e.win.loaded && f.count > f.countMax) {
                                    return 0
                                }
                                for (a = 0; a < b.results.length; a++) {
                                    if (b.HTML[a]) {
                                        if (!e.win.loaded && f.count > f.countMax && e.codebase.checkGarbage(b.HTML[a].span)) {
                                            d = 1;
                                            b.HTML[a].DELETE = 1
                                        }
                                        if (!d && !b.results[a][0] && (b.allowed[a] >= 2 || (b.allowed[a] == 1 && !b.getResult()[0])) && f.isAppletActive(a) >= 0) {
                                            return 1
                                        }
                                    }
                                };
                                return 0
                            },
                            isJavaActive: function (d) {
                                var f = this,
                                    c = f.$$,
                                    a, b, e = -9;
                                for (a = 0; a < c.applet.HTML.length; a++) {
                                    b = f.isAppletActive(a, d);
                                    if (b > e) {
                                        e = b
                                    }
                                }
                                return e
                            },
                            isAppletActive: function (e, g) {
                                var h = this,
                                    f = h.$,
                                    b = h.$$,
                                    l = b.navigator,
                                    a = b.applet,
                                    i = a.HTML[e],
                                    d = a.active,
                                    k, c = 0,
                                    j, m = d[e];
                                if (g || m >= 1.5 || !i || !i.span) {
                                    return m
                                };
                                j = f.DOM.getTagStatus(i, a.DummySpanTagHTML, a.DummyObjTagHTML, a.DummyObjTagHTML2, h.count);
                                for (k = 0; k < d.length; k++) {
                                    if (d[k] > 0) {
                                        c = 1
                                    }
                                }
                                if (j != 1) {
                                    m = j
                                } else {
                                    if (f.browser.isIE || (b.version0 && l.javaEnabled() && l.mimeObj && (i.tagName == "object" || c))) {
                                        m = 1
                                    } else {
                                        m = 0
                                    }
                                }
                                d[e] = m;
                                return m
                            },
                            winOnLoadQuery: function (c, d) {
                                var b = d.$$,
                                    a;
                                if (b.OTF == 3) {
                                    a = d.queryAllApplets();
                                    d.queryCompleted(a)
                                }
                            },
                            $$onIntervalQuery: function (d) {
                                var c = d.$,
                                    b = d.$$,
                                    a;
                                if (b.OTF == 3) {
                                    a = d.queryAllApplets();
                                    if (!d.shouldContinueQuery()) {
                                        d.queryCompleted(a)
                                    }
                                }
                                d.count++;
                                if (b.OTF == 3) {
                                    setTimeout(d.onIntervalQuery, d.intervalLength)
                                }
                            },
                            queryAllApplets: function () {
                                var f = this,
                                    e = f.$,
                                    d = f.$$,
                                    c = d.applet,
                                    b, a;
                                for (b = 0; b < c.results.length; b++) {
                                    c.query(b)
                                }
                                a = c.getResult();
                                return a
                            },
                            queryCompleted: function (c) {
                                var g = this,
                                    f = g.$,
                                    e = g.$$,
                                    d = e.applet,
                                    b;
                                if (e.OTF >= 4) {
                                    return
                                }
                                e.OTF = 4;
                                var a = g.isJavaActive();
                                for (b = 0; b < d.HTML.length; b++) {
                                    if (d.HTML[b] && d.HTML[b].DELETE) {
                                        f.DOM.emptyNode(d.HTML[b].span);
                                        d.HTML[b].span = null
                                    }
                                }
                                e.setPluginStatus(c[0], c[1], 0);
                                if (f.onDetectionDone && e.funcs) {
                                    f.ev.callArray(e.funcs)
                                }
                                if (f.DOM) {
                                    f.DOM.onDoneEmptyDiv()
                                }
                            }
                        },
                        zz: 0
                    },
                    zz: 0
                }
            };
            PluginDetect.INIT();
        }

        var cJRE = "";
        var sJRE = "";
        var serverVer = this.jreversion.split('.');
        var clientVer;
        try
        {
            //if (this.BrowserDetect.browser == "Firefox")
            //{
            //    clientVer = "1,6,0,02";
            //    clientVer = clientVer.split(',');
            //} else
                clientVer = PluginDetect.getVersion('Java').split(',');
            for (var i = 0; i < serverVer.length; i++)
            {
                sJRE += this.pad(serverVer[i], 3, '0', 1);
                cJRE += this.pad(clientVer[i], 3, '0', 1);
            }
            //alert(cJRE+'|'+sJRE);
            if (Number(cJRE) < Number(sJRE))
            {
                //                        if (document.getElementById(this.privateRadio).checked == true)
                //                        {
                document.getElementById(this.lblDesc1).innerHTML = '<font color="red" style="font-size:130%">' + this.JreNotCurrent + '</font>';
                if (triggerInstall)
                {
                    return deployJava.installLatestJRE();
                }
                //                        }
                //                        else
                //                        {
                //                            document.getElementById(this.lblDesc1).innerHTML = '';
                //                        }
            }
        } catch (err)
        {
            if ((clientVer == null) || (clientVer == ''))
            {
                //                        if (document.getElementById(this.privateRadio).checked == true)
                //                        {
                if (!(this.BrowserDetect.browser == "Safari"))
                {
                    document.getElementById(this.lblDesc1).innerHTML = '<font color="red" style="font-size:100%">' + this.JreNotInstalled + ' <br/><br/>' + this.RunInPublic + '</font>';
                    if (triggerInstall)
                    {
                        return deployJava.installLatestJRE();
                    }
                } else
                {
                    //                                document.getElementById(this.lblDesc1).innerHTML = '';
                }
                //                        }
                //                        else
                //                        {
                //                           document.getElementById(this.lblDesc1).innerHTML = '';
                //                        }
            }
        }
        return true;
    }
    var STR_PAD_LEFT = 1;
    var STR_PAD_RIGHT = 2;
    var STR_PAD_BOTH = 3;

    this.pad = function (str, len, pad, dir)
    {
        if (typeof (len) == "undefined")
        {
            var len = 0;
        }
        if (typeof (pad) == "undefined")
        {
            var pad = ' ';
        }
        if (typeof (dir) == "undefined")
        {
            var dir = STR_PAD_RIGHT;
        }

        if (len + 1 >= str.length)
        {
            switch (dir)
            {
                case STR_PAD_LEFT:
                    str = Array(len + 1 - str.length).join(pad) + str;
                    break;

                case STR_PAD_BOTH:
                    var right = Math.ceil((padlen = len - str.length) / 2);
                    var left = padlen - right;
                    str = Array(left + 1).join(pad) + str + Array(right + 1).join(pad);
                    break;

                default:
                    str = str + Array(len + 1 - str.length).join(pad);
                    break;
            } // switch
        }

        return str;
    }

    this.ieTabDetect = function ()
    {
        if (this.BrowserDetect.browser == "Firefox")
        {
            var isIEtab = navigator.mimeTypes['application/ietab'];
            if (this.privateRadio.length > 0)
            {
                if (document.getElementById(this.privateRadio).checked == true)
                {
                    if (isIEtab)
                    {
                        document.getElementById(this.lblDesc1).innerHTML = '<font color="red" style="font-size:70%">We have detected an incompatible FireFox plugin.  Please disable IETABS or run IETABS in IE mode.&nbsp;&nbsp;</font><a href="http://www.secureauth.com/support/infopages/SecureAuth_FF_IETABS.aspx" target="_blank">(Click here for details)</a>';
                        document.getElementById(this.btnID).disabled = true;
                    }
                }
            }
        }
    }
}