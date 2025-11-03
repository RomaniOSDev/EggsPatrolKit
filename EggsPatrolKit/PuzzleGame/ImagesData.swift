
import UIKit

enum PuzzleType {
    case yeasy
    case hard
}
struct PuzzleImagesData {
    let preview: UIImage?
    let elements: [String]
    let type: PuzzleType
}
let puzzleImagesData: [PuzzleImagesData] = [.init(preview: UIImage(named: "puzzle1_EP"),
                                     elements: ["puzzle1_1_EP", "puzzle1_2_EP", "puzzle1_3_EP", "puzzle1_4_EP"],
                                     type: .yeasy),
                                  .init(preview: UIImage(named: "puzzle2_EP"),
                                        elements: ["puzzle2_1_EP", "puzzle2_2_EP", "puzzle2_3_EP", "puzzle2_4_EP"],
                                        type: .yeasy),
                                  .init(preview: UIImage(named: "puzzle3_EP"),
                                        elements: ["puzzle3_1_EP", "puzzle3_2_EP", "puzzle3_3_EP", "puzzle3_4_EP"],
                                        type: .yeasy),
                                  .init(preview: UIImage(named: "puzzle4_EP"),
                                        elements: ["puzzle4_1_EP", "puzzle4_2_EP", "puzzle4_3_EP", "puzzle4_4_EP"],
                                        type: .yeasy),
                                  .init(preview: UIImage(named: "puzzle5_EP"),
                                        elements: ["puzzle5_1_EP", "puzzle5_2_EP", "puzzle5_3_EP", "puzzle5_4_EP"],
                                        type: .yeasy),
                                  .init(preview: UIImage(named: "puzzle6_EP"),
                                        elements: ["puzzle6_1_EP", "puzzle6_2_EP", "puzzle6_3_EP", "puzzle6_4_EP"],
                                        type: .yeasy),
                                  .init(preview: UIImage(named: "puzzle7_EP"),
                                        elements: ["puzzle7_1_EP", "puzzle7_2_EP", "puzzle7_3_EP", "puzzle7_4_EP"],
                                        type: .yeasy),

                                    .init(preview: UIImage(named: "puzzle9_EP"),
                                                  elements: ["puzzle_H1_1_EP", "puzzle_H1_2_EP", "puzzle_H1_3_EP", "puzzle_H1_4_EP", "puzzle_H1_5_EP", "puzzle_H1_6_EP", "puzzle_H1_7_EP", "puzzle_H1_8_EP"],
                                                 type: .hard),
                                            .init(preview: UIImage(named: "puzzle10_EP"),
                                                  elements: ["puzzle_H2_1_EP", "puzzle_H2_2_EP", "puzzle_H2_3_EP", "puzzle_H2_4_EP", "puzzle_H2_5_EP", "puzzle_H2_6_EP", "puzzle_H2_7_EP", "puzzle_H2_8_EP"],
                                                  type: .hard),
                                            .init(preview: UIImage(named: "puzzle11_EP"),
                                                  elements: ["puzzle_H3_1_EP", "puzzle_H3_2_EP", "puzzle_H3_3_EP", "puzzle_H3_4_EP", "puzzle_H3_5_EP", "puzzle_H3_6_EP", "puzzle_H3_7_EP", "puzzle_H3_8_EP"],
                                                  type: .hard),
                                            .init(preview: UIImage(named: "puzzle12_EP"),
                                                  elements: ["puzzle_H4_1_EP", "puzzle_H4_2_EP", "puzzle_H4_3_EP", "puzzle_H4_4_EP", "puzzle_H4_5_EP", "puzzle_H4_6_EP", "puzzle_H4_7_EP", "puzzle_H4_8_EP"],
                                                  type: .hard),
                                            .init(preview: UIImage(named: "puzzle13_EP"),
                                                  elements: ["puzzle_H5_1_EP", "puzzle_H5_2_EP", "puzzle_H5_3_EP", "puzzle_H5_4_EP", "puzzle_H5_5_EP", "puzzle_H5_6_EP", "puzzle_H5_7_EP", "puzzle_H5_8_EP"],
                                                  type: .hard),
                                            .init(preview: UIImage(named: "puzzle14_EP"),
                                                  elements: ["puzzle_H6_1_EP", "puzzle_H6_2_EP", "puzzle_H6_3_EP", "puzzle_H6_4_EP", "puzzle_H6_5_EP", "puzzle_H6_6_EP", "puzzle_H6_7_EP", "puzzle_H6_8_EP"],
                                                  type: .hard),
                                            .init(preview: UIImage(named: "puzzle15_EP"),
                                                  elements: ["puzzle_H7_1_EP", "puzzle_H7_2_EP", "puzzle_H7_3_EP", "puzzle_H7_4_EP", "puzzle_H7_5_EP", "puzzle_H7_6_EP", "puzzle_H7_7_EP", "puzzle_H7_8_EP"],
                                                  type: .hard),
                                            .init(preview: UIImage(named: "puzzle16_EP"),
                                                  elements: ["puzzle_H8_1_EP", "puzzle_H8_2_EP", "puzzle_H8_3_EP", "puzzle_H8_4_EP", "puzzle_H8_5_EP", "puzzle_H8_6_EP", "puzzle_H8_7_EP", "puzzle_H8_8_EP"],
                                                  type: .hard)
]
let yeasyImageNumbers = puzzleImagesData.filter { $0.type == .yeasy }.count
let hardImageNumbers = puzzleImagesData.filter { $0.type == .hard }.count
