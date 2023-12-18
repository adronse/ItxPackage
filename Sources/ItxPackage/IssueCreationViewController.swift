import Foundation
import UIKit

public class IssueCreationViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report a bug"
        self.view.backgroundColor = UIColor.from(hex: "#292A2F")
        configureUI()
        addCloseButton()
    }

    private lazy var IssueCreationTitle = UILabel()
        .with(\.text, value: "cool mec")
        .with(\.textColor, value: UIColor.from(hex: "#11590D"))

    private func configureUI() {
        view.addSubview(IssueCreationTitle)

        IssueCreationTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func addCloseButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        let closeBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }

    @objc private func closeButtonTapped() {
        // Handle close button tap action here
        navigationController?.popViewController(animated: true)
    }
}
