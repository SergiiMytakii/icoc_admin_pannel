#!/usr/bin/env swift

import CoreGraphics
import Foundation
import ImageIO
import NaturalLanguage
import Vision

struct ManifestEntry: Decodable {
  let key: String
  let path: String
}

struct OCRResult: Encodable {
  let key: String
  let ocrText: String?
  let detectedLanguage: String?
  let languageConfidence: Double?
  let width: Double?
  let height: Double?
  let error: String?
}

func normalizeLanguage(_ raw: NLLanguage?) -> String? {
  guard let raw else { return nil }
  switch raw.rawValue.lowercased() {
  case "uk", "ru", "en", "es":
    return raw.rawValue.lowercased()
  default:
    return nil
  }
}

func imagePayload(for path: String) throws -> (CGImage, Double?, Double?) {
  let url = URL(fileURLWithPath: path)
  guard
    let source = CGImageSourceCreateWithURL(url as CFURL, nil),
    let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
  else {
    throw NSError(domain: "ocr", code: 1, userInfo: [NSLocalizedDescriptionKey: "image_load_failed"])
  }

  let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
  let width = (properties?[kCGImagePropertyPixelWidth] as? NSNumber)?.doubleValue
  let height = (properties?[kCGImagePropertyPixelHeight] as? NSNumber)?.doubleValue
  return (image, width, height)
}

func extractOCRText(from image: CGImage) throws -> String {
  let request = VNRecognizeTextRequest()
  request.recognitionLevel = .accurate
  request.usesLanguageCorrection = true
  request.recognitionLanguages = ["uk-UA", "ru-RU", "en-US", "es-ES"]

  let handler = VNImageRequestHandler(cgImage: image, options: [:])
  try handler.perform([request])

  let lines = (request.results ?? [])
    .compactMap { $0.topCandidates(1).first?.string.trimmingCharacters(in: .whitespacesAndNewlines) }
    .filter { !$0.isEmpty }
  return lines.joined(separator: "\n")
}

func detectLanguage(text: String) -> (String?, Double?) {
  let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
  guard !trimmed.isEmpty else { return (nil, nil) }

  let recognizer = NLLanguageRecognizer()
  recognizer.processString(trimmed)
  let hypotheses = recognizer.languageHypotheses(withMaximum: 4)
  let supported = hypotheses.compactMap { key, value -> (String, Double)? in
    guard let normalized = normalizeLanguage(key) else { return nil }
    return (normalized, value)
  }
  .sorted { $0.1 > $1.1 }

  if let best = supported.first {
    return best
  }

  return (normalizeLanguage(recognizer.dominantLanguage), nil)
}

func main() throws {
  guard CommandLine.arguments.count == 2 else {
    fputs("Usage: ocr_detect_image_language.swift <manifest.json>\n", stderr)
    exit(64)
  }

  let manifestPath = CommandLine.arguments[1]
  let data = try Data(contentsOf: URL(fileURLWithPath: manifestPath))
  let entries = try JSONDecoder().decode([ManifestEntry].self, from: data)
  var results: [OCRResult] = []
  results.reserveCapacity(entries.count)

  for entry in entries {
    do {
      let (image, width, height) = try imagePayload(for: entry.path)
      let ocrText = try extractOCRText(from: image)
      let (language, confidence) = detectLanguage(text: ocrText)
      results.append(
        OCRResult(
          key: entry.key,
          ocrText: ocrText.isEmpty ? nil : ocrText,
          detectedLanguage: language,
          languageConfidence: confidence,
          width: width,
          height: height,
          error: nil
        )
      )
    } catch {
      results.append(
        OCRResult(
          key: entry.key,
          ocrText: nil,
          detectedLanguage: nil,
          languageConfidence: nil,
          width: nil,
          height: nil,
          error: error.localizedDescription
        )
      )
    }
  }

  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
  let output = try encoder.encode(results)
  FileHandle.standardOutput.write(output)
}

do {
  try main()
} catch {
  fputs("\(error)\n", stderr)
  exit(1)
}
