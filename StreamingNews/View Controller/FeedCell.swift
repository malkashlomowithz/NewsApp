//
//  FeedCell.swift
//  StreamingNews
//
//  Created by Malky on 11/08/2025.
//


import UIKit
import Kingfisher

class FeedCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor.systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.label
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pubDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let metaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = UIColor.systemBackground
        selectionStyle = .none
        
        // Add subviews
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(containerStackView)
        
        // Setup meta stack view
        metaStackView.addArrangedSubview(authorLabel)
        metaStackView.addArrangedSubview(pubDateLabel)
        
        // Setup container stack view
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(metaStackView)
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Thumbnail image constraints
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            // Container stack view constraints
            containerStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            // Ensure minimum height for the cell
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 112)
        ])
        
        // Set content hugging and compression resistance priorities
        authorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        pubDateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        pubDateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - Configuration
    func configure(with newsItem: NewsItem) {
        titleLabel.text = newsItem.title
        authorLabel.text = newsItem.author
        pubDateLabel.text = formatDate(newsItem.pubDate)
        
        // Load image with Kingfisher
        if let thumbnailURL = URL(string: newsItem.enclosure.link) {
            thumbnailImageView.kf.setImage(
                with: thumbnailURL,
                placeholder: UIImage(systemName: "photo.fill"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo.fill")
        }
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ dateString: String) -> String {
        // Create date formatter for parsing
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Adjust based on your date format
        
        // Create output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        // Fallback: try other common formats
        let commonFormats = [
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd",
            "MMM dd, yyyy",
            "dd/MM/yyyy"
        ]
        
        for format in commonFormats {
            inputFormatter.dateFormat = format
            if let date = inputFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            }
        }
        
        // If all parsing fails, return original string
        return dateString
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        pubDateLabel.text = nil
    }
}

// MARK: - Usage Example
/*
// In your table view controller:

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemTableViewCell
    let newsItem = newsItems[indexPath.row]
    cell.configure(with: newsItem)
    return cell
}

// Don't forget to register the cell in viewDidLoad:
tableView.register(NewsItemTableViewCell.self, forCellReuseIdentifier: "NewsItemCell")

// And set estimated row height for better performance:
tableView.estimatedRowHeight = 112
tableView.rowHeight = UITableView.automaticDimension
*/
