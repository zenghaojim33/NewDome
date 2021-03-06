//
//  ScatterChartData.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 26/2/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

import Foundation
import UIKit

public class ScatterChartData: BarLineScatterCandleChartData
{
    /// Returns the maximum shape-size across all DataSets.
    public func getGreatestShapeSize() -> CGFloat
    {
        var max = CGFloat(0.0);
        
        for set in _dataSets
        {
            let scatterDataSet = set as? ScatterChartDataSet;
            
            if (scatterDataSet == nil)
            {
                println("ScatterChartData: Found a DataSet which is not a ScatterChartDataSet");
            }
            else
            {
                let size = scatterDataSet!.scatterShapeSize;
                
                if (size > max)
                {
                    max = size;
                }
            }
        }
        
        return max;
    }
}
