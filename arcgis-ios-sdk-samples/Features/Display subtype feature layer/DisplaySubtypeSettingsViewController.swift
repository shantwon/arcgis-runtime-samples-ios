// Copyright 2020 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import ArcGIS

class DisplaySubtypeSettingsViewController: UITableViewController {
    // The map whose settings should be adjusted.
    var map: AGSMap!
    var mapScale: Double!
    var minScale: Double!
    var originalRenderer: AGSRenderer!
    var subtypeSublayer: AGSSubtypeSublayer!
    
    @IBOutlet weak var sublayerSwitch: UISwitch!
    @IBOutlet weak var rendererSwitch: UISwitch!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var minScaleLabel: UILabel!
    @IBOutlet weak var setCurrentToMinScale: UITableViewCell!
    
    
    // Change the visibility of the sublayer.
    @IBAction func sublayerSwitchAction(_ sender: UISwitch) {
        subtypeSublayer.isVisible = sender.isOn
    }
    
    // Toggle the type of renderer
    @IBAction func rendererSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            subtypeSublayer.renderer = originalRenderer
        } else {
            let symbol = AGSSimpleMarkerSymbol(style: .diamond, color: .systemPink, size: 20)
            let alternativeRenderer = AGSSimpleRenderer(symbol: symbol)
            subtypeSublayer.renderer = alternativeRenderer
        }
    }
    
    // Change the minimum scale.
    @IBAction func currentToMinAction() {
        minScaleLabel.text = string(fromScale: mapScale)
        subtypeSublayer.minScale = mapScale
    }
    
    // The formatter used to generate strings from scale values.
    private let scaleFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }()
    
    // Returns a string containing the formatted value of the provided scale.
    private func string(fromScale scale: Double) -> String {
        return String(format: "1:%@", scaleFormatter.string(from: scale as NSNumber)!)
    }
    
    // Preserve the states of the switches
    private func preserveSwitchStates() {
        sublayerSwitch.isOn = subtypeSublayer.isVisible
        rendererSwitch.isOn = subtypeSublayer.renderer == originalRenderer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preserveSwitchStates()
        scaleLabel.text = string(fromScale: mapScale)
        let minScale = subtypeSublayer.minScale
        if !minScale.isNaN {
            minScaleLabel.text = string(fromScale: minScale)
        } else {
            minScaleLabel.text = "Not set"
        }
    }
}
