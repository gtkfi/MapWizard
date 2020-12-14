﻿using System.Collections.Generic;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// Permissive Tract model class.
    /// </summary>
    public class PermissiveTractModel : ObservableObject
    {
        private string envpath;
        private List<string> inrasterlist = new List<string> { "" };
        private string outraster;
        private string methodId;
        private List<string> evidenceRasterlist = new List<string> { "" };
        private string unitArea;
        private string maskRaster;
        private string workSpace;
        private string fuzzyOverlayType;
        private string wofEWeightsType;
        private string fuzzyOutputFile;
        private string fuzzyGammaValue;
        private string lastFuzzyRound;
        private string prospectivityRaster;
        private string tractBoundaryValues;
        private List<string> tractBoundaryRasterlist = new List<string> { "" };
        private string evidenceLayerFile;
        private string delId;
        private string minArea;
        private string tractPolygonFile;
        private string delineationRaster;
        private string numbOfProsClasses;
        private string minmaxValues;
        private string tresholdValues;
        private string classificationId;
        private List<string> classifiedRasterlist = new List<string> { "" };
        private string trainingpoints;
        private string arcsdm;
        private string confidenceLevel;
        private string pathToTractPolygon;
        private string explanationOfTract;
        private string idOfTract;
        private string explanationOfRasters;
        private string delRasterFolder;
        private string delRasterFolderWofe;
        private string explanationOfEvidenceRasters;
        private string explanationOfMaskPolygon;
        private string explanationOfTrainingPoints;
        private List<string> delineationCleanFilelist;
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private string selectedTract;
        private string fuzzySplitValue;

        /// <summary>
        /// Environment path.
        /// </summary>
        public string EnvPath
        {
            get
            {
                return envpath;
            }
            set
            {
                Set<string>(() => this.EnvPath, ref envpath, value);
            }
        }

        /// <summary>
        /// List of in rasters.
        /// </summary>
        public List<string> InRasterList
        {
            get
            {
                return inrasterlist;
            }
            set
            {
                Set<List<string>>(() => this.InRasterList, ref inrasterlist, value);
            }
        }

        /// <summary>
        /// Out raster.
        /// </summary>
        public string OutRaster
        {
            get
            {
                return outraster;
            }
            set
            {
                Set<string>(() => this.OutRaster, ref outraster, value);
            }
        }

        /// <summary>
        /// Method Id: Fuzzy / WofE
        /// </summary>
        public string MethodId
        {
            get
            {
                return methodId;
            }
            set
            {
                Set<string>(() => this.MethodId, ref methodId, value);
            }
        }

        /// <summary>
        /// List of evidence rasters.
        /// </summary>
        public List<string> EvidenceRasterlist
        {
            get
            {
                return evidenceRasterlist;
            }
            set
            {
                Set<List<string>>(() => this.EvidenceRasterlist, ref evidenceRasterlist, value);
            }
        }

        /// <summary>
        /// Unit Area
        /// </summary>
        public string UnitArea
        {
            get
            {
                return unitArea;
            }
            set
            {
                Set<string>(() => this.UnitArea, ref unitArea, value);
            }
        }

        /// <summary>
        /// Maskraster
        /// </summary>
        public string MaskRaster
        {
            get
            {
                return maskRaster;
            }
            set
            {
                Set<string>(() => this.MaskRaster, ref maskRaster, value);
            }
        }

        /// <summary>
        /// ArcGis workspace
        /// </summary>
        public string WorkSpace
        {
            get
            {
                return workSpace;
            }
            set
            {
                Set<string>(() => this.WorkSpace, ref workSpace, value);
            }
        }

        /// <summary>
        /// Fuzzy overlay type
        /// </summary>
        public string FuzzyOverlayType
        {
            get
            {
                return fuzzyOverlayType;
            }
            set
            {
                Set<string>(() => this.FuzzyOverlayType, ref fuzzyOverlayType, value);
            }
        }

        /// <summary>
        /// WofE weights calculate type
        /// </summary>
        public string WofEWeightsType
        {
            get
            {
                return wofEWeightsType;
            }
            set
            {
                Set<string>(() => this.WofEWeightsType, ref wofEWeightsType, value);
            }
        }

        /// <summary>
        /// Fuzzy output filename
        /// </summary>
        public string FuzzyOutputFile
        {
            get
            {
                return fuzzyOutputFile;
            }
            set
            {
                Set<string>(() => this.FuzzyOutputFile, ref fuzzyOutputFile, value);
            }
        }

        /// <summary>
        /// Fuzzy gamma value
        /// </summary>
        public string FuzzyGammaValue
        {
            get
            {
                return fuzzyGammaValue;
            }
            set
            {
                Set<string>(() => this.FuzzyGammaValue, ref fuzzyGammaValue, value);
            }
        }

        /// <summary>
        /// Last Fuzzy round
        /// </summary>
        public string LastFuzzyRound
        {
            get
            {
                return lastFuzzyRound;
            }
            set
            {
                Set<string>(() => this.LastFuzzyRound, ref lastFuzzyRound, value);
            }
        }

        /// <summary>
        ///  Prospectivity Raster for delineation process
        /// </summary>
        public string ProspectivityRaster
        {
            get
            {
                return prospectivityRaster;
            }
            set
            {
                Set<string>(() => this.ProspectivityRaster, ref prospectivityRaster, value);
            }
        }

        /// <summary>
        ///  Boundary values for delineation process
        /// </summary>
        public string TractBoundaryValues
        {
            get
            {
                return tractBoundaryValues;
            }
            set
            {
                Set<string>(() => this.TractBoundaryValues, ref tractBoundaryValues, value);
            }
        }

        /// <summary>
        /// List of track boundary rasters.
        /// </summary>
        public List<string> TractBoundaryRasterlist
        {
            get
            {
                return tractBoundaryRasterlist;
            }
            set
            {
                Set<List<string>>(() => this.TractBoundaryRasterlist, ref tractBoundaryRasterlist, value);
            }
        }

        /// <summary>
        /// Evidence layer file
        /// </summary>
        public string EvidenceLayerFile
        {
            get
            {
                return evidenceLayerFile;
            }
            set
            {
                Set<string>(() => this.EvidenceLayerFile, ref evidenceLayerFile, value);
            }
        }

        /// <summary>
        /// DelID will be used as an identifier in file and folder names 
        /// </summary>
        public string DelID
        {
            get
            {
                return delId;
            }
            set
            {
                Set<string>(() => this.DelID, ref delId, value);
            }
        }

        /// <summary>
        /// MinArea, minimum area of polygons to be kept
        /// </summary>
        public string MinArea
        {
            get
            {
                return minArea;
            }
            set
            {
                Set<string>(() => this.MinArea, ref minArea, value);
            }
        }

        /// <summary>
        /// Tract polygon file to be minimized
        /// </summary>
        public string TractPolygonFile
        {
            get
            {
                return tractPolygonFile;
            }
            set
            {
                Set<string>(() => this.TractPolygonFile, ref tractPolygonFile, value);
            }
        }

        /// <summary>
        ///  Delineation Raster for classification process
        /// </summary>
        public string DelineationRaster
        {
            get
            {
                return delineationRaster;
            }
            set
            {
                Set<string>(() => this.DelineationRaster, ref delineationRaster, value);
            }
        }

        /// <summary>
        ///  Number of prospectivity classes for classification process
        /// </summary>
        public string NumbOfProsClasses
        {
            get
            {
                return numbOfProsClasses;
            }
            set
            {
                Set<string>(() => this.NumbOfProsClasses, ref numbOfProsClasses, value);
            }
        }

        /// <summary>
        ///  Raster min/max values for classification process
        /// </summary>
        public string MinMaxValues
        {
            get
            {
                return minmaxValues;
            }
            set
            {
                Set<string>(() => this.MinMaxValues, ref minmaxValues, value);
            }

        }

        /// <summary>
        ///  Treshold values for classification process
        /// </summary>
        public string TresholdValues
        {
            get
            {
                return tresholdValues;
            }
            set
            {
                Set<string>(() => this.TresholdValues, ref tresholdValues, value);
            }
        }

        /// <summary>
        ///  Classification ID for classification process
        /// </summary>
        public string ClassificationId
        {
            get
            {
                return classificationId;
            }
            set
            {
                Set<string>(() => this.ClassificationId, ref classificationId, value);
            }
        }

        /// <summary>
        /// List of classified rasters.
        /// </summary>
        public List<string> ClassifiedRasterlist
        {
            get
            {
                return classifiedRasterlist;
            }
            set
            {
                Set<List<string>>(() => this.ClassifiedRasterlist, ref classifiedRasterlist, value);
            }
        }

        /// <summary>
        /// Training points.
        /// </summary>
        public string TrainingPoints
        {
            get
            {
                return trainingpoints;
            }
            set
            {
                Set<string>(() => this.TrainingPoints, ref trainingpoints, value);
            }
        }

        /// <summary>
        /// ArcSdm location.
        /// </summary>
        public string Arcsdm
        {
            get
            {
                return arcsdm;
            }
            set
            {
                Set<string>(() => this.Arcsdm, ref arcsdm, value);
            }
        }

        /// <summary>
        /// Confidence level for Calculate Weights.
        /// </summary>
        public string ConfidenceLevel
        {
            get
            {
                return confidenceLevel;
            }
            set
            {
                Set<string>(() => this.ConfidenceLevel, ref confidenceLevel, value);
            }
        }


        /// <summary>
        /// Path to polygon layer (Delineation -> input tract polygon)
        /// </summary>
        public string PathToTractPolygon
        {
            get
            {
                return pathToTractPolygon;
            }
            set
            {
                Set<string>(() => this.PathToTractPolygon, ref pathToTractPolygon, value);
            }
        }

        /// <summary>
        /// Explanation of the tract
        /// </summary>
        public string ExplanationOfTract
        {
            get
            {
                return explanationOfTract;
            }
            set
            {
                Set<string>(() => this.ExplanationOfTract, ref explanationOfTract, value);
            }
        }


        /// <summary>
        /// ID of the tract
        /// </summary>
        public string IdOfTract
        {
            get
            {
                return idOfTract;
            }
            set
            {
                Set<string>(() => this.IdOfTract, ref idOfTract, value);
            }
        }

        /// <summary>
        /// Explanation of the rasters that are compined in Fuzzy process
        /// </summary>
        public string ExplanationOfRasters
        {
            get
            {
                return explanationOfRasters;
            }
            set
            {
                Set<string>(() => this.ExplanationOfRasters, ref explanationOfRasters, value);
            }
        }


        /// <summary>
        /// Final deliniation raster folder where fuzzy saves deliniation raster
        /// </summary>
        public string DelRasterFolder
        {
            get
            {
                return delRasterFolder;
            }
            set
            {
                Set<string>(() => this.DelRasterFolder, ref delRasterFolder, value);
            }
        }

        /// <summary>
        /// Final deliniation raster folder where Wofe saves deliniation raster
        /// </summary>
        public string DelRasterFolderWofe
        {
            get
            {
                return delRasterFolderWofe;
            }
            set
            {
                Set<string>(() => this.DelRasterFolderWofe, ref delRasterFolderWofe, value);
            }
        }


        /// <summary>
        /// Explanation Of Evidence Rasters on WofE -process
        /// </summary>
        public string ExplanationOfEvidenceRasters
        {
            get
            {
                return explanationOfEvidenceRasters;
            }
            set
            {
                Set<string>(() => this.ExplanationOfEvidenceRasters, ref explanationOfEvidenceRasters, value);
            }
        }


        /// <summary>
        /// Explanation Of mask polygon on WofE -process
        /// </summary>
        public string ExplanationOfMaskPolygon
        {
            get
            {
                return explanationOfMaskPolygon;
            }
            set
            {
                Set<string>(() => this.ExplanationOfMaskPolygon, ref explanationOfMaskPolygon, value);
            }
        }


        /// <summary>
        /// Explanation Of training points on WofE -process
        /// </summary>
        public string ExplanationOfTrainingPoints
        {
            get
            {
                return explanationOfTrainingPoints;
            }
            set
            {
                Set<string>(() => this.ExplanationOfTrainingPoints, ref explanationOfTrainingPoints, value);
            }
        }


        /// <summary>
        /// Cleaned delineation pdf -file
        /// </summary>
        public List<string> DelineationCleanFilelist
        {
            get
            {
                return delineationCleanFilelist;
            }
            set
            {
                Set<List<string>>(() => this.DelineationCleanFilelist, ref delineationCleanFilelist, value);
            }
        }

        /// <summary>
        /// TractID collection.
        /// </summary>
        public ObservableCollection<string> TractIDNames
        {
            get
            {
                return tractIDNames;
            }
            set
            {
                if (value == null)
                {
                    value = new ObservableCollection<string>();
                }
                Set<ObservableCollection<string>>(() => this.TractIDNames, ref tractIDNames, value);
            }
        }

        /// <summary>
        /// Selected index of TractID Collection.
        /// </summary>
        public string SelectedTract
        {
            get
            {
                return selectedTract;
            }
            set
            {
                Set<string>(() => this.SelectedTract, ref selectedTract, value);
            }
        }


        /// <summary>
        /// Split value of Fuzzy raster process.
        /// </summary>
        public string FuzzySplitValue
        {
            get
            {
                return fuzzySplitValue;
            }
            set
            {
                if (value == null)
                {
                    value = "1";
                }
                Set<string>(() => this.FuzzySplitValue, ref fuzzySplitValue, value);
            }
        }

    }
}
