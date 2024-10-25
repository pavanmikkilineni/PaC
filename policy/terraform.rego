package terraform.s3

import rego.v1

aws_s3_bucket_public_readable(resource) if {
	resource.change.after.acl != "private"
}

deny contains msg if {
	resource := input.resource_changes[_]

	aws_s3_bucket_public_readable(resource)

	msg := {
		"publicId": "AWS-AS3-01.04",
		"title": "S3 Bucket is publicly readable",
		"severity": "medium",
		"msg": sprintf("Bucket Name: [%s]:", [resource.name]),
		"issue": "That this S3 bucket is publicly readable without any authentication or authorization. ",
		"impact": "That you may be leaking sensitive information to members of the public without realizing.",
		"remediation": "Set acl attribute to private, or remove the attribute",
		"references": [],
	}
}

aws_s3_bucket_logging_disaled(resource) if {
	not resource.change.after.logging
}

deny contains msg if {
	resource := input.resource_changes[_]

	aws_s3_bucket_logging_disaled(resource)

	msg := {
		"publicId": "AWS-AS3-01.12",
		"title": "S3 server access logging is disabled",
		"severity": "Medium",
		"msg": sprintf("Bucket Name: [%s]:", [resource.name]),
		"issue": "The s3 access logs will not be collected",
		"impact": "There will be no audit trail of access to s3 objects",
		"remediation": "For AWS provider < v4.0.0, add logging block attribute. For AWS provider >= v4.0.0, add aws_s3_bucket_logging resource.",
		"references": [],
	}
}

aws_s3_bucket_version_lifecycle_policy_check(resource) if {
    resource.change.after.versioning[_].enabled == true
	resource.change.after.lifecycle_rule[_].enabled == false
}{
	resource.change.after.versioning[_].enabled == true
	not resource.change.after.lifecycle_rule
}

deny contains msg if {
	resource := input.resource_changes[_]

	aws_s3_bucket_version_lifecycle_policy_check(resource)

	msg := {
		"publicId": "AWS-AS3-01.09",
		"title": "S3 general purpose versioned bucket Lifecycle configuration disabled",
		"severity": "Medium",
		"msg": sprintf("Bucket Name: [%s]:", [resource.name]),
		"issue": "The versioned S3 bucket lacks lifecycle configuration",
		"impact": "Without lifecycle rules, versioned objects will remain indefinitely, potentially increasing costs",
		"remediation": "For AWS provider < v4.0.0, add lifecycle_rule block attribute. For AWS provider >= v4.0.0, configure lifecycle rules via the aws_s3_bucket_lifecycle_configuration resource.",
		"references": [],
	}
}

aws_s3_bucket_lifecycle_policy_check(resource) if {
	 resource.change.after.versioning[_].enabled == false 
	 resource.change.after.lifecycle_rule[_].enabled == false
}{
	not resource.change.after.versioning
	not resource.change.after.lifecycle_rule
}

deny contains msg if {
	resource := input.resource_changes[_]

	aws_s3_bucket_lifecycle_policy_check(resource)

	msg := {
		"publicId": "AWS-AS3-01.09",
		"title": "S3 general purpose bucket Lifecycle configuration disabled",
		"severity": "Low",
		"msg": sprintf("Bucket Name: [%s]:", [resource.name]),
		"issue": "The S3 bucket lacks lifecycle configuration",
		"impact": "Without lifecycle rules, objects will remain indefinitely, potentially increasing costs",
		"remediation": "For AWS provider < v4.0.0, add lifecycle_rule block attribute. For AWS provider >= v4.0.0, configure lifecycle rules via the aws_s3_bucket_lifecycle_configuration resource.",
		"references": [],
	}
}





